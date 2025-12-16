# app/services/import_service.rb

##
# Serviço responsável por importar turmas e alunos a partir de um arquivo JSON do SIGAA.
# Processa o arquivo, cria/atualiza registros de turmas, usuários e matrículas.
# Mantém controle de sucessos e erros durante a importação.
#
class ImportService
  attr_reader :file_path, :imported_count, :errors

  ##
  # Inicializa o serviço de importação.
  #
  # ==== Argumentos
  # * +file_path+ - (String) Caminho completo do arquivo JSON a ser importado
  #
  # ==== Retorno
  # * +ImportService+ - instância do serviço inicializada
  #
  # ==== Efeitos Colaterais
  # * Inicializa contadores @imported_count = 0 e @errors = []
  #
  # ==== Exemplo
  #   service = ImportService.new('/tmp/uploads/classes.json')
  #
  def initialize(file_path)
    @file_path = file_path
    @imported_count = 0
    @errors = []
  end

  ##
  # Executa a importação completa de turmas e alunos.
  # Processa cada turma do arquivo JSON, criando registros no banco.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Hash+ - resultado da importação com as chaves:
  #   * +:success+ (Boolean) - true se processou sem exceções críticas
  #   * +:imported+ (Integer) - quantidade de turmas importadas com sucesso
  #   * +:errors+ (Array<String>) - lista de erros não-críticos ocorridos
  #   * +:error+ (String) - mensagem de erro crítico (apenas se success: false)
  #
  # ==== Efeitos Colaterais
  # * Lê arquivo JSON do sistema de arquivos
  # * Cria/atualiza registros de Klass, User e ClassMember no banco de dados
  # * Incrementa @imported_count para cada turma processada
  # * Adiciona mensagens em @errors para erros não-críticos
  #
  # ==== Exemplo
  #   service = ImportService.new('/tmp/classes.json')
  #   result = service.import_klasses
  #   # => { success: true, imported: 5, errors: ["Erro ao importar estudante João: Email inválido"] }
  #
  def import_klasses
    data = parse_json_file

    data.each do |klass_data|
      import_single_klass(klass_data)
    end

    { success: true, imported: @imported_count, errors: @errors }
  rescue StandardError => e
    { success: false, error: e.message, imported: @imported_count, errors: @errors }
  end

  private

  ##
  # Faz parse do arquivo JSON e retorna os dados em formato Ruby.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<Hash>+ - array de hashes contendo dados das turmas
  #
  # ==== Efeitos Colaterais
  # * Lê o arquivo do sistema de arquivos via File.read
  # * Levanta exceção se o JSON for inválido ou arquivo não existir
  #
  # ==== Exceções
  # * Levanta RuntimeError com mensagem "Erro ao ler arquivo JSON: ..." se parse falhar
  # * Levanta RuntimeError com mensagem "Arquivo não encontrado: ..." se arquivo não existir
  #
  def parse_json_file
    JSON.parse(File.read(@file_path))
  rescue JSON::ParserError => e
    raise "Erro ao ler arquivo JSON: #{e.message}"
  rescue Errno::ENOENT
    raise "Arquivo não encontrado: #{@file_path}"
  end

  ##
  # Importa uma única turma com seus alunos.
  #
  # ==== Argumentos
  # * +klass_data+ - (Hash) dados da turma no formato JSON do SIGAA
  #
  # ==== Retorno
  # * Nenhum (void)
  #
  # ==== Efeitos Colaterais
  # * Cria/atualiza registro de Klass no banco de dados
  # * Importa todos os alunos da turma via import_students
  # * Incrementa @imported_count em 1
  # * Adiciona erro em @errors se falhar (não levanta exceção)
  #
  def import_single_klass(klass_data)
    klass = find_or_create_klass(klass_data)
    import_students(klass, klass_data['dicente'])
    @imported_count += 1
  rescue StandardError => e
    @errors << "Erro ao importar turma #{klass_data['code']}: #{e.message}"
  end

  ##
  # Busca ou cria uma turma no banco de dados.
  #
  # ==== Argumentos
  # * +klass_data+ - (Hash) dados da turma contendo 'code', 'name' e 'class'
  #
  # ==== Retorno
  # * +Klass+ - objeto da turma (existente ou recém-criado)
  #
  # ==== Efeitos Colaterais
  # * Executa query no banco (find_or_create_by)
  # * Cria novo registro de Klass se não existir com aquele código
  # * Atualiza campos name, semester e description se criando novo registro
  #
  def find_or_create_klass(klass_data)
    klass_info = klass_data['class']

    Klass.find_or_create_by(code: klass_data['code']) do |klass|
      klass.name = klass_data['name']
      klass.semester = klass_info['semester']
      klass.description = "Turma #{klass_info['classCode']} - #{klass_info['time']}"
    end
  end

  ##
  # Importa todos os alunos de uma turma.
  #
  # ==== Argumentos
  # * +klass+ - (Klass) objeto da turma onde os alunos serão matriculados
  # * +students_data+ - (Array<Hash>) lista de dados dos alunos em formato JSON
  #
  # ==== Retorno
  # * Nenhum (void) - retorna nil se students_data estiver vazio
  #
  # ==== Efeitos Colaterais
  # * Chama import_single_student para cada aluno na lista
  # * Nenhuma alteração direta no banco (delegado ao import_single_student)
  #
  def import_students(klass, students_data)
    return unless students_data.present?

    students_data.each do |student_data|
      import_single_student(klass, student_data, 'dicente')
    end
  end

  ##
  # Importa um único aluno e o matricula na turma.
  #
  # ==== Argumentos
  # * +klass+ - (Klass) turma onde o aluno será matriculado
  # * +student_data+ - (Hash) dados do aluno (nome, email, matrícula, etc)
  # * +role+ - (String) papel do usuário na turma (geralmente 'dicente')
  #
  # ==== Retorno
  # * Nenhum (void)
  #
  # ==== Efeitos Colaterais
  # * Cria/busca registro de User via find_or_create_user
  # * Cria registro de ClassMember vinculando user e klass
  # * Adiciona erro em @errors se falhar (não levanta exceção)
  #
  def import_single_student(klass, student_data, role)
    user = find_or_create_user(student_data)

    ClassMember.find_or_create_by(user: user, klass: klass) do |cm|
      cm.role = role
    end
  rescue StandardError => e
    @errors << "Erro ao importar estudante #{student_data['nome']}: #{e.message}"
  end

  ##
  # Busca usuário existente por email ou cria um novo.
  #
  # ==== Argumentos
  # * +user_data+ - (Hash) dados do usuário contendo email, nome, matrícula, etc
  #
  # ==== Retorno
  # * +User+ - objeto do usuário (existente ou recém-criado)
  #
  # ==== Efeitos Colaterais
  # * Executa query no banco (find_by)
  # * Pode criar novo User via create_new_user se não existir
  #
  def find_or_create_user(user_data)
    User.find_by(email: user_data['email']) || create_new_user(user_data)
  end

  ##
  # Cria e persiste um novo usuário no banco de dados.
  #
  # ==== Argumentos
  # * +user_data+ - (Hash) dados completos do usuário
  #
  # ==== Retorno
  # * +User+ - objeto do usuário recém-criado e salvo
  #
  # ==== Efeitos Colaterais
  # * Cria novo registro de User no banco via save
  # * Levanta exceção se validações falharem
  #
  # ==== Exceções
  # * Levanta RuntimeError com mensagens de validação se user.save falhar
  #
  def create_new_user(user_data)
    user = build_user(user_data)

    if user.save
      user
    else
      raise "Erro ao salvar usuário #{user_data['email']}: #{user.errors.full_messages.join(', ')}"
    end
  end

  ##
  # Constrói objeto User em memória com os dados fornecidos.
  # Define a matrícula como senha padrão do usuário.
  #
  # ==== Argumentos
  # * +user_data+ - (Hash) dados do usuário do JSON
  #
  # ==== Retorno
  # * +User+ - objeto User não persistido (apenas em memória)
  #
  # ==== Efeitos Colaterais
  # * Nenhum (apenas cria objeto em memória, não salva no banco)
  #
  def build_user(user_data)
    password = user_data['matricula']

    User.new(
      email: user_data['email'],
      name: user_data['nome'],
      matricula: user_data['matricula'],
      curso: user_data['curso'],
      formacao: user_data['formacao'],
      ocupacao: user_data['ocupacao'],
      password: password,
      password_confirmation: password,
      role: :user
    )
  end
end
