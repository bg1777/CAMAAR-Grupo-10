# language: pt
Funcionalidade: Login no Sistema CAMAAR
  Como usuário do sistema (admin ou dicente)
  Eu quero fazer login com minhas credenciais
  Para acessar o sistema e suas funcionalidades

  Contexto:
    Dado que o banco de dados está limpo
    E um usuário admin existe com:
      | email              | senha123 |
      | nome               | Admin    |
    E um usuário dicente existe com:
      | email              | dicente@example.com |
      | nome               | João Silva          |
      | matricula          | 202201234           |

  # HAPPY PATH
  Cenário: Admin faz login com sucesso
    Quando acesso a página de login
    E preencho o email com "admin@example.com"
    E preencho a senha com "senha123"
    E clico no botão "Log in"
    Então devo estar autenticado como "admin@example.com"
    E devo ser redirecionado para o dashboard admin
    E devo ver a mensagem "Bem-vindo, Admin"

  Cenário: Dicente faz login com sucesso
    Quando acesso a página de login
    E preencho o email com "dicente@example.com"
    E preencho a senha com "202201234"
    E clico no botão "Log in"
    Então devo estar autenticado como "dicente@example.com"
    E devo ser redirecionado para o dashboard estudante
    E devo ver meus formulários pendentes

  # SAD PATH
  Cenário: Login falha com email inexistente
    Quando acesso a página de login
    E preencho o email com "inexistente@example.com"
    E preencho a senha com "qualquersenha"
    E clico no botão "Log in"
    Então devo ver a mensagem de erro "E-mail ou senha inválidos"
    E não devo estar autenticado
    E devo permanecer na página de login

  Cenário: Login falha com senha incorreta
    Quando acesso a página de login
    E preencho o email com "dicente@example.com"
    E preencho a senha com "senhaerrada"
    E clico no botão "Log in"
    Então devo ver a mensagem de erro "E-mail ou senha inválidos"
    E não devo estar autenticado
    E devo permanecer na página de login

  Cenário: Login falha com campos vazios
    Quando acesso a página de login
    E deixo o email vazio
    E deixo a senha vazia
    E clico no botão "Log in"
    Então devo ver uma mensagem de validação
    E não devo estar autenticado
