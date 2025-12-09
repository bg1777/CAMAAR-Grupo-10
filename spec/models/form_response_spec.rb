# spec/models/form_response_spec.rb

require 'rails_helper'

RSpec.describe FormResponse, type: :model do
  let(:user) { create(:user, role: :admin) }
  let(:student) { create(:user, role: :user) }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template, user: user) }
  let(:form) { create(:form, form_template: form_template, klass: klass) }
  let(:form_response) { create(:form_response, form: form, user: student) }

  describe 'associations' do
    it { is_expected.to belong_to(:form) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:form_answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:form_id) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'uniqueness validation' do
    it 'não permite duplicar resposta de mesmo user para mesmo form' do
      create(:form_response, form: form, user: student)
      
      duplicate = build(:form_response, form: form, user: student)
      expect(duplicate).not_to be_valid
    end

    it 'permite mesmo user responder forms diferentes' do
      form2 = create(:form, form_template: form_template, klass: klass)
      
      response1 = create(:form_response, form: form, user: student)
      response2 = build(:form_response, form: form2, user: student)
      
      expect(response2).to be_valid
    end
  end

  describe '#create' do
    it 'cria resposta válida' do
      expect {
        create(:form_response, form: form, user: student)
      }.to change(FormResponse, :count).by(1)
    end

    it 'não cria resposta sem form' do
      response = build(:form_response, form: nil, user: student)
      expect(response).not_to be_valid
    end

    it 'não cria resposta sem user' do
      response = build(:form_response, form: form, user: nil)
      expect(response).not_to be_valid
    end
  end

  describe '#completed?' do
    it 'retorna false quando submitted_at é nil' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      expect(response.completed?).to be false
    end

    it 'retorna true quando submitted_at está presente' do
      response = create(:form_response, form: form, user: student, submitted_at: Time.current)
      expect(response.completed?).to be true
    end
  end

  describe '#pending?' do
    it 'retorna true quando resposta não foi enviada' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      expect(response.pending?).to be true
    end

    it 'retorna false quando resposta foi enviada' do
      response = create(:form_response, form: form, user: student, submitted_at: Time.current)
      expect(response.pending?).to be false
    end
  end
end