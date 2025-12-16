# language: pt
Funcionalidade: Visualizar Respostas de Formulários (Admin)
  Como administrador
  Eu quero visualizar todas as respostas dos alunos
  Para analisar os resultados dos formulários

  Contexto:
    Dado que sou um usuário admin autenticado
    E existe um formulário publicado "Pesquisa de Satisfação"
    E 3 alunos responderam o formulário com:
      | aluno      | nome_do_aluno  | email                | opiniao                   | recomendacao |
      | João       | João Silva     | joao@example.com     | Excelente aula           | Sim          |
      | Maria      | Maria Santos   | maria@example.com    | Boa aula, mas poderia... | Talvez       |
      | Pedro      | Pedro Oliveira | pedro@example.com    | Aula cansativa           | Não          |

  # HAPPY PATH
  Cenário: Visualizar todas as respostas de um formulário
    Quando acesso a página de formulários
    E clico no formulário "Pesquisa de Satisfação"
    Então devo ver o status "3 de 3 responderam"
    E devo ver a lista de alunos que responderam
    E devo conseguir expandir/clicar em cada resposta para ver os detalhes

  Cenário: Visualizar detalhes de uma resposta específica
    Quando acesso o formulário "Pesquisa de Satisfação"
    E clico em "Ver" ou na resposta de "João Silva"
    Então devo ver todos os campos e respostas dele:
      | Nome do aluno: | João Silva        |
      | Email:         | joao@example.com  |
      | Opinião:       | Excelente aula    |
      | Recomendação:  | Sim               |
    E devo ver a data de submissão
    E devo conseguir voltar à lista de respostas

  Cenário: Filtrar respostas por status
    Dado que existem 5 alunos na turma, mas só 3 responderam
    Quando acesso o formulário
    Então devo ver:
      | Total de alunos: | 5 |
      | Responderam:     | 3 |
      | Pendentes:       | 2 |
    E devo conseguir filtrar para ver apenas os pendentes

  Cenário: Visualizar formulário com nenhuma resposta
    Dado que existe um formulário publicado há pouco com 0 respostas
    Quando acesso o formulário
    Então devo ver o status "0 de 5 responderam"
    E devo ver a mensagem "Nenhuma resposta ainda"
    E devo ver a lista de alunos que ainda não responderam

  # SAD PATH
  Cenário: Admin não consegue ver respostas de formulário fechado
    Dado que existe um formulário que foi fechado
    Quando acesso o formulário
    Então devo conseguir ver as respostas já coletadas
    E a página deve indicar que o formulário está fechado

  Cenário: Admin pode acessar qualquer formulário
    Dado que existe um formulário criado por outro admin
    Quando clico nele
    Então devo conseguir visualizar
    # Por design, qualquer admin consegue acessar qualquer formulário

  Cenário: Usuário não-admin não consegue visualizar respostas
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de resposta de um formulário
    Então devo ser redirecionado para a página inicial
    E devo ver a mensagem "Acesso negado!"
