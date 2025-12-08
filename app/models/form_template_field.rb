# app/models/form_template_field.rb

class FormTemplateField < ApplicationRecord
  belongs_to :form_template
  has_many :form_answers, dependent: :destroy

  validates :field_type, presence: true, inclusion: { in: %w(text textarea number email multiple_choice), message: '%{value} is not a valid field type' }
  validates :label, presence: true
  validates :position, presence: true
  validates :form_template_id, presence: true
end