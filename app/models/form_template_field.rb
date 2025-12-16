# app/models/form_template_field.rb

class FormTemplateField < ApplicationRecord
  belongs_to :form_template
  has_many :form_answers, dependent: :destroy
  
  # Valores válidos para field_type
  VALID_FIELD_TYPES = %w(text textarea email number date select radio checkbox).freeze
  
  validates :label, presence: true
  validates :field_type, presence: true, inclusion: { in: VALID_FIELD_TYPES }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  # Validar options apenas para tipos que precisam
  validates :options, presence: true, if: :requires_options?
  
  # Callback para garantir que position seja integer
  before_validation :ensure_position_is_integer
  
  private
  
  def requires_options?
    ['select', 'radio', 'checkbox'].include?(field_type)
  end
  
  def ensure_position_is_integer
    self.position = position.to_i if position.present? && position.is_a?(String)
  end
end
