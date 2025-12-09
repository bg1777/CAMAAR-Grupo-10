# app/models/form_template_field.rb

class FormTemplateField < ApplicationRecord
  belongs_to :form_template
  
  validates :label, presence: true
  validates :field_type, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  
  # Validar options apenas para tipos que precisam
  validates :options, presence: true, if: :requires_options?
  
  private
  
  def requires_options?
    ['select', 'radio', 'checkbox'].include?(field_type)
  end
end
