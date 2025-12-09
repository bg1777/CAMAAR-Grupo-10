# spec/models/form_spec.rb

require 'rails_helper'

RSpec.describe Form, type: :model do
  let(:user) { create(:user, role: :admin) }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template, user: user) }
  let(:form) { create(:form, form_template: form_template, klass: klass) }

  describe 'associations' do
    it { is_expected.to belong_to(:form_template) }
    it { is_expected.to belong_to(:klass) }
    it { is_expected.to have_many(:form_responses).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:form_template_id) }
    it { is_expected.to validate_presence_of(:klass_id) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#create' do
    it 'cria um formulário válido' do
      expect {
        create(:form, form_template: form_template, klass: klass)
      }.to change(Form, :count).by(1)
    end

    it 'não cria form sem título' do
      form_obj = build(:form, title: nil, form_template: form_template, klass: klass)
      expect(form_obj).not_to be_valid
    end

    it 'não cria form sem template' do
      form_obj = build(:form, form_template: nil, klass: klass)
      expect(form_obj).not_to be_valid
    end

    it 'não cria form sem turma' do
      form_obj = build(:form, form_template: form_template, klass: nil)
      expect(form_obj).not_to be_valid
    end
  end

  describe 'enum status' do
    it 'tem draft como status padrão' do
      form_obj = create(:form, form_template: form_template, klass: klass)
      expect(form_obj.status).to eq('draft')
    end

    it 'pode ter status published' do
      form.update(status: :published)
      expect(form.published?).to be true
    end

    it 'pode ter status closed' do
      form.update(status: :closed)
      expect(form.closed?).to be true
    end
  end

  describe '#pending_responses' do
    it 'retorna alunos que não responderam' do
      student1 = create(:user, role: :user)
      student2 = create(:user, role: :user)
      
      create(:class_member, user: student1, klass: klass, role: 'dicente')
      create(:class_member, user: student2, klass: klass, role: 'dicente')
      
      create(:form_response, form: form, user: student1)
      
      pending = form.pending_responses
      expect(pending).to include(student2)
      expect(pending).not_to include(student1)
    end
  end

  describe '#completed_responses' do
    it 'retorna alunos que responderam' do
      student1 = create(:user, role: :user)
      student2 = create(:user, role: :user)
      
      create(:class_member, user: student1, klass: klass, role: 'dicente')
      create(:class_member, user: student2, klass: klass, role: 'dicente')
      
      create(:form_response, form: form, user: student1)
      
      completed = form.completed_responses
      expect(completed).to include(student1)
      expect(completed).not_to include(student2)
    end
  end
end