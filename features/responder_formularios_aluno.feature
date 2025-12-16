# language: pt
Funcionalidade: Responder Formulários como Aluno
  Como aluno (dicente)
  Eu quero responder formulários publicados da minha turma
  Para participar das pesquisas e avaliações

  Contexto:
    Dado que sou um usuário dicente autenticado
    E estou inscrito na turma "CC001"

  # HAPPY PATH
  Cenário: Visualizar formulários pendentes
    Dado que existe um formulário publicado "Pesquisa de Satisfação" para minha turma
    Quando acesso meu dashboard de formulários
    Então devo ver a seção "Formulários Pendentes"
    E devo ver o formulário "Pesquisa de Satisfação" na lista

  Cenário: Acessar página de responder formulário
    Dado que existe um formulário publicado "Pesquisa de Satisfação" para minha turma
    Quando acesso meu dashboard de formulários
    E clico no link "Responder Formulário"
    Então devo ver a página de resposta do formulário

  Cenário: Formulários pendentes e respondidos aparecem separados
    Dado que já respondi 2 formulários
    E existem 3 formulários publicados na minha turma
    Quando acesso meu dashboard de formulários
    Então devo ver a seção "Formulários Pendentes"
    E devo ver a seção "Formulários Respondidos"
    E a seção de respondidos deve ter 2 formulários

  Cenário: Visualizar formulário já respondido
    Dado que existe um formulário publicado que já respondi
    Quando acesso meu dashboard de formulários
    E clico em "Ver" na seção de respondidos
    Então devo ver "Formulário respondido"
    E devo ver minhas respostas anteriores

  # SAD PATH
  Cenário: Aluno não consegue acessar formulário de outra turma
    Dado que existe um formulário publicado para a turma "CC002"
    E não estou inscrito na turma "CC002"
    Quando tento acessar esse formulário diretamente
    Então devo ser redirecionado para a página inicial

  Cenário: Formulário em rascunho não aparece para aluno
    Dado que existe um formulário em status "Rascunho" da minha turma
    Quando acesso meu dashboard de formulários
    Então o formulário não deve aparecer na lista de pendentes

  Cenário: Formulário fechado não aparece para aluno
    Dado que existe um formulário em status "Fechado" da minha turma
    Quando acesso meu dashboard de formulários
    Então o formulário não deve aparecer na lista de pendentes
