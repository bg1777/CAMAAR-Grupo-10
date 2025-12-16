# language: pt
Funcionalidade: Importar Turmas e Alunos via JSON
  Como administrador
  Eu quero importar turmas e alunos de um arquivo JSON
  Para registrar os dados dos estudantes no sistema de forma automatizada

  Contexto:
    Dado que sou um usuário admin autenticado

  # HAPPY PATH
  Cenário: Acessar página de importação
    Quando acesso a página de importação (/admin/imports)
    Então devo ver o formulário de upload de arquivo
    E devo ver as instruções de importação

  Cenário: Visualizar estatísticas da importação
    Dado que existem 3 turmas importadas
    E existem 10 alunos registrados
    Quando acesso a página de importação
    Então devo ver "3" turmas no total
    E devo ver "10" alunos no total

  # SAD PATH
  Cenário: Usuário não-admin não consegue acessar importação
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de importação (/admin/imports)
    Então devo ser redirecionado para a página inicial
