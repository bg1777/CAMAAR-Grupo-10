# language: pt
Funcionalidade: Visualizar Respostas de Formulários (Admin)
  Como administrador
  Eu quero visualizar todas as respostas dos alunos
  Para analisar os resultados dos formulários

  Contexto:
    Dado que sou um usuário admin autenticado

  # HAPPY PATH
  Cenário: Visualizar lista de respostas de um formulário
    Dado que existe um formulário publicado "Pesquisa de Satisfação"
    E 3 alunos responderam o formulário
    Quando acesso a página do formulário
    Então devo ver a seção "Respostas"
    E devo ver 3 respostas na tabela
    E cada resposta deve ter o nome do aluno
    E cada resposta deve mostrar o status "Respondido"

  Cenário: Visualizar detalhes de uma resposta específica
    Dado que existe um formulário publicado com respostas
    E um aluno "João Silva" respondeu o formulário
    Quando acesso a página do formulário
    E clico em "Ver Respostas" na linha do aluno
    Então devo ver o nome "João Silva"
    E devo ver a data de submissão
    E devo ver todas as perguntas e respostas dele

  Cenário: Visualizar formulário sem respostas
    Dado que existe um formulário publicado sem respostas
    Quando acesso a página do formulário
    Então devo ver a mensagem "Nenhum aluno respondeu ainda"

  Cenário: Visualizar formulário fechado com respostas
    Dado que existe um formulário em status "Fechado"
    E 2 alunos responderam antes de fechar
    Quando acesso a página do formulário
    Então devo ver o badge "Fechado"
    E devo conseguir ver as 2 respostas coletadas

  Cenário: Admin pode acessar formulários de outros admins
    Dado que existe um formulário criado por outro admin
    Quando acesso esse formulário
    Então devo conseguir visualizar o formulário
    E devo conseguir ver as respostas

  # SAD PATH
  Cenário: Usuário não-admin não consegue visualizar respostas
    Dado que sou um usuário dicente autenticado
    E existe um formulário publicado
    Quando tento acessar a página admin do formulário
    Então devo ser redirecionado para a página inicial
