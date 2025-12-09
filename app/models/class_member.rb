# app/models/class_member.rb

class ClassMember < ApplicationRecord
  # Associações
  belongs_to :user
  belongs_to :klass

  # Validações
  validates :user_id, uniqueness: { scope: :klass_id, message: 'já está inscrito nesta turma' }
  validates :role, presence: true, inclusion: { in: %w(dicente docente), message: 'deve ser dicente ou docente' }
end