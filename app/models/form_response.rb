# app/models/form_response.rb

##
# Representa a resposta de um usuário a um formulário específico.
# Armazena o estado de submissão e gerencia as respostas individuais de cada campo (form_answers).
#
class FormResponse < ApplicationRecord
  belongs_to :form
  belongs_to :user
  has_many :form_answers, dependent: :destroy

  validates :form_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :form_id, message: 'já respondeu este formulário' }

  accepts_nested_attributes_for :form_answers

  ##
  # Verifica se a resposta foi submetida (finalizada).
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Boolean+ - true se submitted_at está preenchido, false caso contrário
  #
  # ==== Efeitos Colaterais
  # * Nenhum (método de leitura)
  #
  # ==== Exemplo
  #   response = FormResponse.find(1)
  #   response.completed? # => true
  #
  def completed?
    submitted_at.present?
  end

  ##
  # Verifica se a resposta ainda está pendente (não submetida).
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Boolean+ - true se ainda não foi submetida, false caso contrário
  #
  # ==== Efeitos Colaterais
  # * Nenhum (método de leitura)
  #
  # ==== Exemplo
  #   response = FormResponse.find(1)
  #   response.pending? # => false
  #
  def pending?
    !completed?
  end

  ##
  # Cria objetos FormAnswer vazios para todos os campos do template associado.
  # Utilizado para preparar o formulário antes do usuário preencher.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<FormAnswer>+ - lista de form_answers criados (ainda não salvos no banco)
  #
  # ==== Efeitos Colaterais
  # * Cria objetos FormAnswer em memória (não persiste no banco até save)
  # * Executa query para buscar form_template_fields ordenados por position
  # * Não cria duplicatas (verifica se já existe form_answer para o campo)
  #
  # ==== Exemplo
  #   response = FormResponse.new(form: form, user: user)
  #   response.build_answers_for_fields
  #   response.form_answers.count # => 5 (número de campos do template)
  #
  def build_answers_for_fields
    form.form_template.form_template_fields.order(:position).each do |field|
      unless form_answers.exists?(form_template_field_id: field.id)
        form_answers.build(form_template_field: field, answer: '')
      end
    end
  end

  ##
  # Marca a resposta como submetida, registrando o timestamp atual.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Boolean+ - true se salvou com sucesso, false caso contrário
  #
  # ==== Efeitos Colaterais
  # * Atualiza o campo submitted_at no banco de dados com Time.current
  # * Persiste a mudança imediatamente (executa UPDATE)
  #
  # ==== Exemplo
  #   response = FormResponse.find(1)
  #   response.submit! # => true
  #   response.completed? # => true
  #
  def submit!
    update(submitted_at: Time.current)
  end
end
