# language: pt
Funcionalidade: Criar e Gerenciar Templates de Formulários
  Como administrador
  Eu quero criar templates de formulários reutilizáveis
  Para usar como base na criação de múltiplos formulários

  Contexto:
    Dado que sou um usuário admin autenticado

  # HAPPY PATH
  Cenário: Criar template com sucesso
    Quando acesso a página de templates de formulários (/admin/form_templates)
    E clico no botão "Novo Template"
    E preencho o nome com "Pesquisa de Satisfação"
    E preencho a descrição com "Template para coletar feedback dos alunos"
    E adiciono um campo de texto com label "Nome do aluno"
    E adiciono um campo de email com label "Email" (obrigatório)
    E adiciono um campo select com label "Semestre" e opções ["2025.1", "2025.2"]
    E clico no botão "Criar"
    E devo ser redirecionado para a página do template
    E o template deve estar listado na página de templates

  Cenário: Editar template com sucesso
    Dado que existe um template chamado "Pesquisa de Satisfação"
    Quando acesso o template
    E clico no botão "Editar"
    E altero o nome para "Pesquisa de Satisfação - v2"
    E adiciono um novo campo de texto com label "Comentários"
    E clico no botão "Salvar Alterações"
    E o template deve ter o novo nome
    E o novo campo deve estar presente

  Cenário: Deletar template com sucesso
    Dado que existe um template chamado "Pesquisa Antiga"
    Quando acesso o template
    E clico no botão "Deletar"
    E confirmo a deleção
    E o template não deve estar mais listado

  Cenário: Listar todos os templates criados
    Dado que existem 3 templates criados pelo admin
    Quando acesso a página de templates
    Então devo ver todos os 3 templates listados
    E cada template deve mostrar seu nome, descrição e data de criação

  # SAD PATH
  Cenário: Falha ao criar template sem nome
    Quando acesso a página de criação de template
    E deixo o nome vazio
    E preencho a descrição com "Uma descrição"
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação "Nome não pode ficar em branco"
    E o template não deve ser criado

  Cenário: Falha ao criar template sem descrição
    Quando acesso a página de criação de template
    E preencho o nome com "Template Incompleto"
    E deixo a descrição vazia
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação "Descrição não pode ficar em branco"
    E o template não deve ser criado

  Cenário: Falha ao criar template sem campos
    Quando acesso a página de criação de template
    E preencho o nome com "Template Sem Campos"
    E preencho a descrição com "Uma descrição"
    E não adiciono nenhum campo
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação
    E o template não deve ser criado

  Cenário: Campo obrigatório sem label
    Quando acesso a página de criação de template
    E preencho o nome com "Template"
    E preencho a descrição com "Uma descrição"
    E clico em "Adicionar Campo"
    E seleciono o tipo "text"
    E deixo o label vazio
    E clico em "Marcar como obrigatório"
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação sobre o label do campo
    E o template não deve ser criado

  Cenário: Campo select sem opções
    Quando acesso a página de criação de template
    E preencho o nome com "Template"
    E preencho a descrição com "Uma descrição"
    E clico em "Adicionar Campo"
    E seleciono o tipo "select"
    E preencho o label com "Escolha"
    E deixo as opções vazias
    E clico no botão "Criar"
    Então devo ver uma mensagem de validação "Select deve ter opções"
    E o template não deve ser criado

  Cenário: Usuário não-admin não consegue criar template
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de criação de template (/admin/form_templates/new)
    Então devo ser redirecionado para a página inicial
