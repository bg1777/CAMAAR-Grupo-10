# app/models/user.rb

class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum :role, { user: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
