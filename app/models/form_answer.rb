# app/models/form_answer.rb

##
# Representa a resposta individual de um campo específico dentro de um formulário.
# Armazena o valor preenchido pelo usuário para cada FormTemplateField.
#
class FormAnswer < ApplicationRecord
  belongs_to :form_response
  belongs_to :form_template_field

  validates :form_response_id, presence: true
  validates :form_template_field_id, presence: true
  validates :answer, presence: true
end
