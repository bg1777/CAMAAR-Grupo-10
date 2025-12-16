# app/models/user.rb

##
# Representa um usuário do sistema, podendo ser administrador ou aluno (dicente).
# Gerencia autenticação, permissões e relacionamentos com turmas e formulários.
#
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

  ##
  # Verifica se o usuário possui perfil de administrador.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Boolean+ - true se o usuário é admin, false caso contrário
  #
  # ==== Efeitos Colaterais
  # * Nenhum (método de leitura)
  #
  # ==== Exemplo
  #   user = User.find(1)
  #   user.admin? # => true
  #
  def admin?
    role == 'admin'
  end

  ##
  # Verifica se o usuário possui perfil de aluno/dicente.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +Boolean+ - true se o usuário é dicente, false caso contrário
  #
  # ==== Efeitos Colaterais
  # * Nenhum (método de leitura)
  #
  # ==== Exemplo
  #   user = User.find(2)
  #   user.user? # => true
  #
  def user?
    role == 'user'
  end

  ##
  # Retorna todos os formulários publicados que o usuário ainda não respondeu.
  # Considera apenas formulários das turmas em que o usuário está inscrito.
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +ActiveRecord::Relation+ - coleção de objetos Form pendentes de resposta
  #
  # ==== Efeitos Colaterais
  # * Executa queries no banco de dados para buscar formulários
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   user = User.find(2)
  #   user.pending_forms # => [#<Form id: 1, ...>, #<Form id: 3, ...>]
  #
  def pending_forms
    Form
      .where(klass_id: klasses.pluck(:id), status: :published)
      .where.not(
        id: form_responses.where.not(submitted_at: nil).pluck(:form_id)
      )
  end

  ##
  # Retorna todos os formulários que o usuário já respondeu (submetidos).
  #
  # ==== Argumentos
  # * Nenhum
  #
  # ==== Retorno
  # * +ActiveRecord::Relation+ - coleção de objetos Form já respondidos
  #
  # ==== Efeitos Colaterais
  # * Executa queries no banco de dados para buscar formulários
  # * Nenhuma alteração de dados
  #
  # ==== Exemplo
  #   user = User.find(2)
  #   user.completed_forms # => [#<Form id: 2, ...>, #<Form id: 4, ...>]
  #
  def completed_forms
    Form
      .where(id: form_responses.where.not(submitted_at: nil).pluck(:form_id))
  end
end
