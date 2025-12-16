# app/models/form_template.rb

##
# Representa um modelo/template reutilizável de formulário.
# Criado por administradores para servir de base na criação de múltiplos formulários.
# Contém campos personalizáveis que definem a estrutura do formulário.
#
class FormTemplate < ApplicationRecord
  belongs_to :user
  has_many :form_template_fields, dependent: :destroy
  has_many :forms, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :form_template_fields, allow_destroy: true
end
