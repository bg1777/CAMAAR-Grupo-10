# language: pt
Funcionalidade: Responder Formulários como Aluno
  Como aluno (dicente)
  Eu quero responder formulários publicados da minha turma
  Para participar das pesquisas e avaliações

  Contexto:
    Dado que sou um usuário dicente autenticado
    E estou inscrito na turma "CC001"
    E existe um formulário publicado "Pesquisa de Satisfação" para minha turma com os campos:
      | field_type | label                    | required | options                    |
      | text       | Nome do aluno           | true     |                            |
      | email      | Email para contato      | true     |                            |
      | textarea   | Qual sua opinião?       | false    |                            |
      | select     | Recomendaria a aula?    | true     | Sim,Não,Talvez             |

  # HAPPY PATH
  Cenário: Responder formulário com sucesso
    Quando acesso meu dashboard de formulários
    E clico no formulário "Pesquisa de Satisfação"
    Então devo ver os campos do formulário
    E devo responder o campo "Nome do aluno" com "João Silva"
    E devo responder o campo "Email para contato" com "joao@example.com"
    E devo responder o campo "Qual sua opinião?" com "Ótima aula, muito aproveitoso!"
    E devo selecionar "Sim" no campo "Recomendaria a aula?"
    E clico no botão "Enviar Resposta"
    Então devo ver a mensagem "Formulário respondido com sucesso!"
    E o formulário deve aparecer na minha lista de formulários respondidos
    E não devo conseguir responder o mesmo formulário novamente

  Cenário: Responder formulário com campos opcionais vazios
    Quando acesso meu dashboard de formulários
    E clico no formulário "Pesquisa de Satisfação"
    E devo responder o campo "Nome do aluno" com "Maria Silva"
    E devo responder o campo "Email para contato" com "maria@example.com"
    E deixo o campo "Qual sua opinião?" vazio (porque é opcional)
    E devo selecionar "Não" no campo "Recomendaria a aula?"
    E clico no botão "Enviar Resposta"
    Então devo ver a mensagem "Formulário respondido com sucesso!"
    E o formulário deve aparecer na minha lista de formulários respondidos

  Cenário: Visualizar formulário antes de responder
    Quando acesso meu dashboard de formulários
    E vejo o formulário "Pesquisa de Satisfação" na lista de pendentes
    E clico no botão "Ver" ao lado do formulário
    Então devo ver uma pré-visualização do formulário
    E devo ver todos os campos que preciso responder
    E devo poder voltar sem criar uma resposta

  Cenário: Formulários pendentes e respondidos aparecem separados
    Dado que já respondi 2 formulários
    E existem 3 formulários publicados na minha turma
    Quando acesso meu dashboard de formulários
    Então devo ver a seção "Formulários Pendentes" com 1 formulário
    E devo ver a seção "Formulários Respondidos" com 2 formulários

  # SAD PATH
  Cenário: Falha ao responder sem preencher campo obrigatório
    Quando acesso meu dashboard de formulários
    E clico no formulário "Pesquisa de Satisfação"
    E devo responder o campo "Nome do aluno" com "João Silva"
    E deixo o campo "Email para contato" vazio (obrigatório)
    E deixo o campo "Qual sua opinião?" vazio
    E seleciono "Sim" no campo "Recomendaria a aula?"
    E clico no botão "Enviar Resposta"
    Então devo ver uma mensagem de erro "Email para contato não pode ficar em branco"
    E a resposta não deve ser salva
    E permaneço na página de resposta do formulário

  Cenário: Falha ao responder com email inválido
    Quando acesso meu dashboard de formulários
    E clico no formulário "Pesquisa de Satisfação"
    E devo responder o campo "Nome do aluno" com "João Silva"
    E devo responder o campo "Email para contato" com "emailinvalido"
    E devo responder o campo "Qual sua opinião?" com "Boa aula"
    E devo selecionar "Sim" no campo "Recomendaria a aula?"
    E clico no botão "Enviar Resposta"
    Então devo ver uma mensagem de erro "Email inválido"
    E a resposta não deve ser salva

  Cenário: Aluno não consegue responder formulário de outra turma
    Dado que existe um formulário publicado para a turma "CC002" (que não sou membro)
    Quando tento acessar esse formulário
    Então devo ser redirecionado para meu dashboard
    E devo ver a mensagem "Acesso negado a este formulário"

  Cenário: Aluno não consegue responder formulário não publicado
    Dado que existe um formulário em status "Rascunho" da minha turma
    Quando tento acessar esse formulário no meu dashboard
    Então ele não deve aparecer na minha lista de formulários
    E não consigo acessá-lo diretamente pela URL

  Cenário: Aluno não consegue responder formulário fechado
    Dado que existe um formulário que foi publicado e depois fechado
    Quando acesso meu dashboard de formulários
    Então o formulário não deve aparecer na lista de pendentes
    E se tentar acessá-lo pela URL, devo ver a mensagem "Este formulário foi fechado"

  Cenário: Formulário não aparece para aluno não inscrito na turma
    Dado que existe um formulário publicado para a turma "CC001"
    E sou um aluno inscrito apenas na turma "CC002"
    Quando acesso meu dashboard de formulários
    Então o formulário de CC001 não deve aparecer na minha lista
