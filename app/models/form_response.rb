# app/models/form_response.rb

class FormResponse < ApplicationRecord
  belongs_to :form
  belongs_to :user
  has_many :form_answers, dependent: :destroy

  validates :form_id, presence: true
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: :form_id, message: 'já respondeu este formulário' }

  accepts_nested_attributes_for :form_answers

  def completed?
    submitted_at.present?
  end

  def pending?
    !completed?
  end

  # Inicializar answers para todos os fields (sem validação)
  def build_answers_for_fields
    form.form_template.form_template_fields.order(:position).each do |field|
      # Só adicionar se ainda não existe
      unless form_answers.exists?(form_template_field_id: field.id)
        form_answers.build(form_template_field: field, answer: '')
      end
    end
    save(validate: false) if persisted?
  end

  # Marcar como submetido
  def submit!
    update(submitted_at: Time.current)
  end
end
