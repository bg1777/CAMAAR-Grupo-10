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
    E clico no link "Novo Formulário"
    E seleciono o template "Pesquisa de Satisfação"
    E seleciono a turma "CC001"
    E preencho o título com "Pesquisa - Algoritmos - 2025.1"
    E preencho a descrição com "Sua opinião é importante para melhorar o curso"
    E clico no botão "Criar Formulário"
    Então o formulário deve estar com status "Rascunho"
    E o formulário deve estar listado na página de formulários

  Cenário: Publicar formulário com sucesso
    Dado que existe um formulário em status "Rascunho"
    Quando acesso a página de formulários
    E clico no botão "Publicar"
    Então o formulário deve ter status "Publicado"

  Cenário: Fechar formulário com sucesso
    Dado que existe um formulário em status "Publicado"
    Quando acesso o formulário na página show
    E clico no botão "Fechar"
    Então o formulário deve ter status "Fechado"

  Cenário: Editar formulário em rascunho
    Dado que existe um formulário em status "Rascunho" com título "Pesquisa v1"
    Quando acesso o formulário na página show
    E clico no link "Editar"
    E altero o título para "Pesquisa v2"
    E clico no botão "Atualizar Formulário"
    Então o formulário deve ter o novo título "Pesquisa v2"

  Cenário: Listar todos os formulários
    Dado que existem 3 formulários criados
    Quando acesso a página de formulários
    Então devo ver todos os 3 formulários listados

  # SAD PATH
  Cenário: Falha ao criar formulário sem título
    Quando acesso a página de criação de formulário
    E seleciono o template "Pesquisa de Satisfação"
    E seleciono a turma "CC001"
    E deixo o título vazio
    E preencho a descrição com "Uma descrição"
    E clico no botão "Criar Formulário"
    Então o formulário não deve ser criado

  Cenário: Falha ao editar formulário já publicado
    Dado que existe um formulário em status "Publicado"
    Quando acesso o formulário na página show
    Então não devo ver o botão "Editar"

  Cenário: Usuário não-admin não consegue criar formulário
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de criação de formulário (/admin/forms/new)
    Então devo ser redirecionado para a página inicial
