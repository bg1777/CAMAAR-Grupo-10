# language: pt
Funcionalidade: Criar e Publicar Formulários
  Como administrador
  Eu quero criar formulários baseados em templates
  E publicar para que alunos de uma turma possam responder

  Contexto:
    Dado que sou um usuário admin autenticado
    E existe um template de formulário chamado "Pesquisa de Satisfação"
    E existe uma turma "CC001" com 3 alunos registrados

  # HAPPY PATH
  Cenário: Criar formulário com sucesso
    Quando acesso a página de formulários (/admin/forms)
    E clico no botão "Novo Formulário"
    E seleciono o template "Pesquisa de Satisfação"
    E seleciono a turma "CC001"
    E preencho o título com "Pesquisa - Algoritmos - 2025.1"
    E preencho a descrição com "Sua opinião é importante para melhorar o curso"
    E defino a data de vencimento para "2025-12-31"
    E clico no botão "Criar"
    Então devo ver a mensagem "Formulário criado com sucesso!"
    E o formulário deve estar com status "Rascunho"
    E o formulário deve estar listado na página de formulários

  Cenário: Publicar formulário com sucesso
    Dado que existe um formulário em status "Rascunho"
    Quando acesso o formulário
    E clico no botão "Publicar"
    Então devo ver a mensagem "Formulário publicado com sucesso!"
    E o formulário deve ter status "Publicado"
    E os alunos da turma devem conseguir visualizá-lo como formulário pendente

  Cenário: Fechar formulário com sucesso
    Dado que existe um formulário em status "Publicado"
    Quando acesso o formulário
    E clico no botão "Fechar"
    Então devo ver a mensagem "Formulário fechado com sucesso!"
    E o formulário deve ter status "Fechado"
    E os alunos não devem conseguir responder mais

  Cenário: Editar formulário em rascunho
    Dado que existe um formulário em status "Rascunho" com título "Pesquisa v1"
    Quando acesso o formulário
    E clico no botão "Editar"
    E altero o título para "Pesquisa v2"
    E altero a data de vencimento para "2025-12-25"
    E clico no botão "Atualizar"
    Então devo ver a mensagem "Formulário atualizado com sucesso!"
    E o formulário deve ter o novo título

  Cenário: Visualizar progresso de respostas
    Dado que existe um formulário publicado
    E 2 de 3 alunos já responderam
    Quando acesso o formulário
    Então devo ver o progresso "2 de 3 responderam"
    E devo ver a lista de alunos que responderam
    E devo ver a lista de alunos que ainda não responderam

  Cenário: Deletar formulário em rascunho
    Dado que existe um formulário em status "Rascunho"
    Quando acesso o formulário
    E clico no botão "Deletar"
    E confirmo a deleção
    Então devo ver a mensagem "Formulário deletado com sucesso!"
    E o formulário não deve estar mais listado

  # SAD PATH
  Cenário: Falha ao criar formulário sem template
    Quando acesso a página de criação de formulário
    E não seleciono nenhum template
    E seleciono uma turma
    E preencho o título e descrição
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação
    E o formulário não deve ser criado

  Cenário: Falha ao criar formulário sem turma
    Quando acesso a página de criação de formulário
    E seleciono o template "Pesquisa de Satisfação"
    E não seleciono nenhuma turma
    E preencho o título e descrição
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação
    E o formulário não deve ser criado

  Cenário: Falha ao criar formulário sem título
    Quando acesso a página de criação de formulário
    E seleciono o template "Pesquisa de Satisfação"
    E seleciono a turma "CC001"
    E deixo o título vazio
    E preencho a descrição
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação "Título não pode ficar em branco"
    E o formulário não deve ser criado

  Cenário: Falha ao editar formulário já publicado
    Dado que existe um formulário em status "Publicado"
    Quando acesso o formulário
    E clico no botão "Editar"
    Então devo ver uma mensagem "Não é possível editar um formulário publicado"
    E a página de edição não deve ser carregada

  Cenário: Usuário não-admin não consegue criar formulário
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de criação de formulário (/admin/forms/new)
    Então devo ser redirecionado para a página inicial
    E devo ver a mensagem "Acesso negado!"
