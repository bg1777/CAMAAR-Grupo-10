# app/models/form.rb

##
# Representa um formulário publicado para uma turma específica.
# Baseado em um FormTemplate, possui status (rascunho, publicado, fechado)
# e armazena as respostas dos alunos através de FormResponse.
#
class Form < ApplicationRecord
  belongs_to :form_template
  belongs_to :klass
  has_many :form_responses, dependent: :destroy

  validates :form_template_id, presence: true
  validates :klass_id, presence: true
  validates :title, presence: true

  enum :status, { draft: 0, published: 1, closed: 2 }

  # Definir status padrão
  before_create :set_default_status

  ##
  # Retorna todos os alunos da turma que ainda não responderam o formulário.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<User>+ - lista de alunos que ainda não submeteram respostas
  #
  # ==== Efeitos Colaterais
  # * Executa queries no banco de dados (klass.students e form_responses)
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   form = Form.find(1)
  #   form.pending_responses # => [#<User id: 2, name: "João">]
  #
  def pending_responses
    klass.students - form_responses.map(&:user)
  end

  ##
  # Retorna todos os alunos que já responderam o formulário.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<User>+ - lista de alunos que já submeteram respostas
  #
  # ==== Efeitos Colaterais
  # * Executa query no banco de dados através de form_responses
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   form = Form.find(1)
  #   form.completed_responses # => [#<User id: 3, name: "Maria">]
  #
  def completed_responses
    form_responses.map(&:user)
  end

  private

  ##
  # Define o status padrão do formulário como 'draft' (rascunho)
  # quando o formulário é criado pela primeira vez.
  # Executado automaticamente pelo callback before_create.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Symbol+ - :draft (status padrão)
  #
  # ==== Efeitos Colaterais
  # * Modifica o atributo status do objeto para :draft se ainda não estiver definido
  # * Executado automaticamente antes de criar o registro no banco
  #
  def set_default_status
    self.status ||= :draft
  end
end
