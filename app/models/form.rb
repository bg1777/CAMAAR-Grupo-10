# app/models/form.rb

class Form < ApplicationRecord
  belongs_to :form_template
  belongs_to :klass
  has_many :form_responses, dependent: :destroy

  validates :form_template_id, presence: true
  validates :klass_id, presence: true
  validates :title, presence: true

  enum :status, { draft: 0, published: 1, closed: 2 }

  # Retorna todos os alunos da turma que ainda não responderam o formulário
  def pending_responses
    klass.students - form_responses.map(&:user)
  end

  # Retorna alunos que já responderam
  def completed_responses
    form_responses.map(&:user)
  end
end