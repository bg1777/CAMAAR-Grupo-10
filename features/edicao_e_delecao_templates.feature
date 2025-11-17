Feature: Edição e deleção de templates
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Background:
    Given que estou autenticado como administrador
    And existe um template criado previamente

  Scenario: Editar o nome de um template com sucesso (feliz)
    When eu edito o template alterando seu nome para "Template Atualizado"
    Then o template deve ser salvo com o novo nome
    And os formulários já criados anteriormente não devem ser modificados
    And eu devo ver a mensagem "Template atualizado com sucesso"

  Scenario: Editar as perguntas de um template com sucesso (feliz)
    When eu edito o template alterando suas perguntas
    Then o template deve ser salvo com as novas perguntas
    And os formulários já criados anteriormente não devem ser modificados
    And eu devo ver a mensagem "Template atualizado com sucesso"

  Scenario: Deletar um template com sucesso (feliz)
    When eu deleto o template
    Then o template deve ser removido do sistema
    And os formulários já criados anteriormente devem permanecer intactos
    And eu devo ver a mensagem "Template excluído com sucesso"

  Scenario: Tentar editar um template que está em uso por um formulário ativo (triste)
    Given que o template está vinculado a um formulário ativo
    When eu tento editar o template
    Then a alteração deve ser bloqueada
    And eu devo ver a mensagem "Não é possível editar um template em uso"

  Scenario: Tentar deletar um template que está em uso por um formulário ativo (triste)
    Given que o template está vinculado a um formulário ativo
    When eu tento deletar o template
    Then a remoção deve ser bloqueada
    And eu devo ver a mensagem "Não é possível remover um template em uso"
