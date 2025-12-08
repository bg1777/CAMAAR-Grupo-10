# app/services/import_service.rb

class ImportService
  attr_reader :file_path, :imported_count, :errors

  def initialize(file_path)
    @file_path = file_path
    @imported_count = 0
    @errors = []
  end

  # Importa turmas com seus estudantes
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

  def parse_json_file
    JSON.parse(File.read(@file_path))
  rescue JSON::ParserError => e
    raise "Erro ao ler arquivo JSON: #{e.message}"
  rescue Errno::ENOENT
    raise "Arquivo não encontrado: #{@file_path}"
  end

  def import_single_klass(klass_data)
    klass = find_or_create_klass(klass_data)
    
    # Importar estudantes
    import_students(klass, klass_data['dicente'])
    
    @imported_count += 1
  rescue StandardError => e
    @errors << "Erro ao importar turma #{klass_data['code']}: #{e.message}"
  end

  def find_or_create_klass(klass_data)
    klass_info = klass_data['class']
    
    Klass.find_or_create_by(code: klass_data['code']) do |klass|
      klass.name = klass_data['name']
      klass.semester = klass_info['semester']
      klass.description = "Turma #{klass_info['classCode']} - #{klass_info['time']}"
    end
  end

  def import_students(klass, students_data)
    return unless students_data.present?

    students_data.each do |student_data|
      import_single_student(klass, student_data, 'dicente')
    end
  end

  def import_single_student(klass, student_data, role)
    user = find_or_create_user(student_data)
    
    ClassMember.find_or_create_by(user: user, klass: klass) do |cm|
      cm.role = role
    end
  rescue StandardError => e
    @errors << "Erro ao importar estudante #{student_data['nome']}: #{e.message}"
  end

  def find_or_create_user(user_data)
    user = User.find_by(email: user_data['email'])
    
    if user.present?
      return user
    end

    password = SecureRandom.hex(12)

    user = User.new(
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

    if user.save
      user
    else
      raise "Erro ao salvar usuário #{user_data['email']}: #{user.errors.full_messages.join(', ')}"
    end
  end
end