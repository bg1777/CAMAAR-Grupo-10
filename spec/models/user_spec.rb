# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validações' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    
    it 'validates email uniqueness' do
      user1 = create(:user, email: 'unique@example.com')
      user2 = build(:user, email: 'unique@example.com')
      
      expect(user2).not_to be_valid
    end
  end

  describe 'criação de usuário' do
    it 'cria um usuário com dados válidos' do
      user = User.create(
        name: 'João Silva',
        email: 'joao@example.com',
        password: 'senha123',
        password_confirmation: 'senha123',
        role: :user
      )
      
      expect(user).to be_persisted
      expect(user.user?).to be true
    end

    it 'não cria usuário sem nome' do
      user = User.new(
        email: 'teste@example.com',
        password: 'senha123',
        password_confirmation: 'senha123'
      )
      
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'não cria usuário com email duplicado' do
      User.create(
        name: 'João',
        email: 'joao@example.com',
        password: 'senha123',
        password_confirmation: 'senha123'
      )

      user2 = User.new(
        name: 'Maria',
        email: 'joao@example.com',
        password: 'senha123',
        password_confirmation: 'senha123'
      )
      
      expect(user2).not_to be_valid
    end
  end

  describe 'roles' do
    it 'cria um usuário admin' do
      admin = User.create(
        name: 'Administrador',
        email: 'admin@example.com',
        password: 'senha123',
        password_confirmation: 'senha123',
        role: :admin
      )

      expect(admin.admin?).to be true
      expect(admin.role).to eq('admin')
    end
  end
end