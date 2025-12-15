# app/models/user.rb

class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :validatable

  enum :role, { user: 0, admin: 1 }

  # Associações
  has_many :class_members, dependent: :destroy
  has_many :klasses, through: :class_members
  has_many :form_templates, dependent: :destroy
  has_many :form_responses, dependent: :destroy

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # Métodos auxiliares
  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  # Formulários pendentes (não respondidos)
  def pending_forms
    Form
      .where(klass_id: klasses.pluck(:id), status: :published)
      .where.not(
        id: form_responses.where.not(submitted_at: nil).pluck(:form_id)
      )
  end

  # Formulários já respondidos
  def completed_forms
    Form
      .where(id: form_responses.where.not(submitted_at: nil).pluck(:form_id))
  end
end