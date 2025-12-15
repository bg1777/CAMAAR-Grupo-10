# app/models/form_template_field.rb

class FormTemplateField < ApplicationRecord
  belongs_to :form_template
  has_many :form_answers, dependent: :destroy
  
  # Valores válidos para field_type
  VALID_FIELD_TYPES = %w(text textarea email number date select radio checkbox).freeze
  
  validates :form_template_id, presence: true
  validates :label, presence: true
  validates :field_type, presence: true, inclusion: { in: VALID_FIELD_TYPES }
  validates :position, presence: true, numericality: { only_integer: true }
  
  # Validar options apenas para tipos que precisam
  validates :options, presence: true, if: :requires_options?
  
  private
  
  def requires_options?
    ['select', 'radio', 'checkbox'].include?(field_type)
  end
end
