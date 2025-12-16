# language: pt
Funcionalidade: Criar e Gerenciar Templates de Formulários
  Como administrador
  Eu quero criar templates de formulários reutilizáveis
  Para usar como base na criação de múltiplos formulários

  Contexto:
    Dado que sou um usuário admin autenticado

  # HAPPY PATH
  Cenário: Listar todos os templates criados
    Dado que existem 3 templates criados pelo admin
    Quando acesso a página de templates
    Então devo ver todos os 3 templates listados

  Cenário: Deletar template com sucesso
    Dado que existe um template chamado "Pesquisa Antiga"
    Quando acesso a página de templates
    E clico no botão "Deletar"
    Então o template não deve estar mais listado

  # SAD PATH
  Cenário: Falha ao criar template sem nome
    Quando acesso a página de criação de template
    E deixo o nome vazio
    E preencho a descrição com "Uma descrição"
    E clico no botão "Criar Template"
    Então o template não deve ser criado

  Cenário: Falha ao criar template sem descrição
    Quando acesso a página de criação de template
    E preencho o nome com "Template Incompleto"
    E deixo a descrição vazia
    E clico no botão "Criar Template"
    Então o template não deve ser criado

  Cenário: Usuário não-admin não consegue criar template
    Dado que sou um usuário dicente autenticado
    Quando tento acessar a página de criação de template (/admin/form_templates/new)
    Então devo ser redirecionado para a página inicial
