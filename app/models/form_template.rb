# app/models/form_template.rb

class FormTemplate < ApplicationRecord
  belongs_to :user
  has_many :form_template_fields, dependent: :destroy
  has_many :forms, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :form_template_fields, allow_destroy: true
end