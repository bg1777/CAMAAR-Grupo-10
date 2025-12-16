# language: pt
Funcionalidade: Importar Turmas e Alunos via JSON
  Como administrador
  Eu quero importar turmas e alunos de um arquivo JSON
  Para registrar os dados dos estudantes no sistema de forma automatizada

  Contexto:
    Dado que sou um usuário admin autenticado

  # HAPPY PATH
  Cenário: Importação bem-sucedida de turmas e alunos
    Dado que tenho um arquivo JSON válido com:
      | code    | name            | semester | dicente                                    |
      | CC001   | Algoritmos      | 2025.1   | {"nome": "João Silva", "email": "joao@example.com", "matricula": "202201001", "curso": "Computação", "formacao": "Graduação", "ocupacao": "Estudante"} |
      | CC002   | Banco de Dados  | 2025.1   | {"nome": "Maria Santos", "email": "maria@example.com", "matricula": "202201002", "curso": "Computação", "formacao": "Graduação", "ocupacao": "Estudante"} |
    Quando acesso a página de importação (/admin/imports)
    E faço upload do arquivo JSON
    E clico no botão "Importar"
    Então devo ver a mensagem "✅ 2 turma(s) importada(s) com sucesso!"
    E as turmas devem estar registradas no banco de dados
    E os usuários devem estar criados com suas credenciais

  Cenário: Importação parcial com erros
    Dado que tenho um arquivo JSON com alguns dados inválidos:
      | code    | name            | semester | dicente                                    |
      | CC001   | Algoritmos      | 2025.1   | {"nome": "João Silva", "email": "joao@example.com", "matricula": "202201001", "curso": "Computação", "formacao": "Graduação", "ocupacao": "Estudante"} |
      | CC002   | Banco de Dados  | 2025.1   | {"nome": "", "email": "invalid", "matricula": "202201002"} |
    Quando acesso a página de importação
    E faço upload do arquivo JSON
    E clico no botão "Importar"
    Então devo ver a mensagem "✅ 1 turma(s) importada(s) com sucesso!"
    E devo ver um aviso com "1 erro(s) durante importação"
    E a turma CC001 deve estar registrada
    E a turma CC002 não deve estar registrada (ou sem o aluno inválido)

  # SAD PATH
  Cenário: Falha ao fazer upload sem selecionar arquivo
    Quando acesso a página de importação
    E não seleciono nenhum arquivo
    E clico no botão "Importar"
    Então devo ver a mensagem de erro "Por favor, selecione um arquivo"
    E nenhum dado deve ser importado

  Cenário: Falha ao fazer upload de arquivo inválido
    Dado que tenho um arquivo em formato inválido (ex: .csv, .txt)
    Quando acesso a página de importação
    E faço upload do arquivo inválido
    E clico no botão "Importar"
    Então devo ver a mensagem de erro "Por favor, envie um arquivo JSON válido"
    E nenhum dado deve ser importado

  Cenário: Falha ao fazer upload de arquivo JSON malformado
    Dado que tenho um arquivo JSON com sintaxe inválida
    Quando acesso a página de importação
    E faço upload do arquivo malformado
    E clico no botão "Importar"
    Então devo ver a mensagem de erro contendo "Erro ao ler arquivo JSON"
    E nenhum dado deve ser importado

  Cenário: Usuário não-admin não consegue acessar importação
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de importação (/admin/imports)
    Então devo ser redirecionado para a página inicial
    E devo ver a mensagem "Acesso negado!"
