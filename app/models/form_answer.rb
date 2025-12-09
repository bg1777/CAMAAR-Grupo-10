# app/models/form_answer.rb

class FormAnswer < ApplicationRecord
  belongs_to :form_response
  belongs_to :form_template_field

  validates :form_response_id, presence: true
  validates :form_template_field_id, presence: true
  validates :answer, presence: true
end