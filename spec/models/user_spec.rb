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

    it 'cria um usuário comum (user)' do
      user = User.create(
        name: 'João',
        email: 'joao@example.com',
        password: 'senha123',
        password_confirmation: 'senha123',
        role: :user
      )

      expect(user.user?).to be true
      expect(user.admin?).to be false
    end

    it 'admin? retorna true para admin' do
      admin = create(:user, role: :admin)
      expect(admin.admin?).to be true
    end

    it 'admin? retorna false para user' do
      user = create(:user, role: :user)
      expect(user.admin?).to be false
    end

    it 'user? retorna true para user' do
      user = create(:user, role: :user)
      expect(user.user?).to be true
    end

    it 'user? retorna false para admin' do
      admin = create(:user, role: :admin)
      expect(admin.user?).to be false
    end
  end

  describe 'associações' do
    it { should have_many(:class_members).dependent(:destroy) }
    it { should have_many(:klasses).through(:class_members) }
    it { should have_many(:form_templates).dependent(:destroy) }
    it { should have_many(:form_responses).dependent(:destroy) }
  end

  describe '#pending_forms' do
    let(:admin) { create(:user, role: :admin) }
    let(:student) { create(:user, role: :user) }
    let(:klass) { create(:klass) }
    let(:form_template) { create(:form_template, user: admin) }

    before do
      create(:class_member, user: student, klass: klass, role: 'dicente')
    end

    it 'retorna forms publicados que não foram respondidos' do
      form = create(:form, form_template: form_template, klass: klass, status: :published)

      pending = student.pending_forms
      expect(pending).to include(form)
    end

    it 'não retorna forms que foram respondidos' do
      form = create(:form, form_template: form_template, klass: klass, status: :published)
      create(:form_response, form: form, user: student, submitted_at: Time.current)

      pending = student.pending_forms
      expect(pending).not_to include(form)
    end

    it 'não retorna forms que não estão publicados' do
      form = create(:form, form_template: form_template, klass: klass, status: :draft)

      pending = student.pending_forms
      expect(pending).not_to include(form)
    end

    it 'não retorna forms com prazo expirado' do
      form = create(:form, 
        form_template: form_template, 
        klass: klass, 
        status: :published,
        due_date: 1.day.ago
      )

      pending = student.pending_forms
      expect(pending).not_to include(form)
    end

    it 'retorna forms com prazo futuro' do
      form = create(:form, 
        form_template: form_template, 
        klass: klass, 
        status: :published,
        due_date: 1.day.from_now
      )

      pending = student.pending_forms
      expect(pending).to include(form)
    end

    it 'retorna forms sem prazo definido' do
      form = create(:form, 
        form_template: form_template, 
        klass: klass, 
        status: :published,
        due_date: nil
      )

      pending = student.pending_forms
      expect(pending).to include(form)
    end

    it 'retorna apenas forms das turmas do aluno' do
      klass2 = create(:klass)
      form1 = create(:form, form_template: form_template, klass: klass, status: :published)
      form2 = create(:form, form_template: form_template, klass: klass2, status: :published)

      pending = student.pending_forms
      expect(pending).to include(form1)
      expect(pending).not_to include(form2)
    end
  end

  describe '#completed_forms' do
    let(:admin) { create(:user, role: :admin) }
    let(:student) { create(:user, role: :user) }
    let(:klass) { create(:klass) }
    let(:form_template) { create(:form_template, user: admin) }

    before do
      create(:class_member, user: student, klass: klass, role: 'dicente')
    end

    it 'retorna forms que foram respondidos' do
      form = create(:form, form_template: form_template, klass: klass, status: :published)
      create(:form_response, form: form, user: student, submitted_at: Time.current)

      completed = student.completed_forms
      expect(completed).to include(form)
    end

    it 'não retorna forms não respondidos' do
      form = create(:form, form_template: form_template, klass: klass, status: :published)

      completed = student.completed_forms
      expect(completed).not_to include(form)
    end

    it 'não retorna forms com resposta não submetida' do
      form = create(:form, form_template: form_template, klass: klass, status: :published)
      create(:form_response, form: form, user: student, submitted_at: nil)

      completed = student.completed_forms
      expect(completed).not_to include(form)
    end

    it 'retorna múltiplos forms respondidos' do
      form1 = create(:form, form_template: form_template, klass: klass, status: :published)
      form2 = create(:form, form_template: form_template, klass: klass, status: :published)
      
      create(:form_response, form: form1, user: student, submitted_at: Time.current)
      create(:form_response, form: form2, user: student, submitted_at: Time.current)

      completed = student.completed_forms
      expect(completed.count).to eq(2)
      expect(completed).to include(form1, form2)
    end

    it 'retorna array vazio quando nenhum form foi respondido' do
      create(:form, form_template: form_template, klass: klass, status: :published)

      completed = student.completed_forms
      expect(completed).to be_empty
    end
  end

  describe 'devise' do
    it 'inclui database_authenticatable' do
      user = create(:user)
      expect(user.respond_to?(:valid_password?)).to be true
    end

    it 'inclui validatable' do
      user = build(:user, password: 'abc')
      expect(user.valid?).to be false
    end
  end
end
