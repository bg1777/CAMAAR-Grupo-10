# app/models/user.rb

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para role
  enum :role, { user: 0, admin: 1 }

  # Validações
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  # Métodos úteis
  def admin?
    role == 'admin'
  end
end
