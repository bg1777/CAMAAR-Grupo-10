# app/models/klass.rb

class Klass < ApplicationRecord
  # Associações
  has_many :class_members, dependent: :destroy
  has_many :users, through: :class_members
  has_many :forms, dependent: :destroy

  # Validações
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :semester, presence: true

  # Scopes
  scope :active, -> { order(semester: :desc) }

  # Métodos úteis
  def students
    class_members.where(role: 'dicente').map(&:user)
  end

  def teachers
    class_members.where(role: 'docente').map(&:user)
  end
end