# app/models/klass.rb

##
# Representa uma turma/disciplina do sistema (ex: "Banco de Dados").
# Gerencia alunos, professores e formulários associados à turma.
#
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

  ##
  # Retorna todos os alunos (dicentes) matriculados na turma.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<User>+ - lista de usuários com perfil de aluno (role: 'dicente')
  #
  # ==== Efeitos Colaterais
  # * Executa queries no banco de dados através da associação class_members
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   klass = Klass.find_by(code: 'CC001')
  #   klass.students # => [#<User id: 2, name: "João">, #<User id: 3, name: "Maria">]
  #
  def students
    class_members.where(role: 'dicente').map(&:user)
  end

  ##
  # Retorna todos os professores (docentes) associados à turma.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Array<User>+ - lista de usuários com perfil de professor (role: 'docente')
  #
  # ==== Efeitos Colaterais
  # * Executa queries no banco de dados através da associação class_members
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   klass = Klass.find_by(code: 'CC001')
  #   klass.teachers # => [#<User id: 1, name: "Prof. Silva">]
  #
  def teachers
    class_members.where(role: 'docente').map(&:user)
  end
end
