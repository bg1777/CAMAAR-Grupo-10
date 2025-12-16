# app/models/class_member.rb

##
# Representa a matrícula de um usuário em uma turma.
# Estabelece o relacionamento entre User e Klass, definindo o papel (dicente ou docente).
#
class ClassMember < ApplicationRecord
  # Associações
  belongs_to :user
  belongs_to :klass

  # Validações
  validates :user_id, uniqueness: { scope: :klass_id, message: 'já está inscrito nesta turma' }
  validates :role, presence: true, inclusion: { in: %w(dicente docente), message: 'deve ser dicente ou docente' }
end
