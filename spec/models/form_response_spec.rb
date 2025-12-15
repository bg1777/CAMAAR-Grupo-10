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

  describe '#build_answers_for_fields' do
    before do
      # Criar fields para o template
      create(:form_template_field, form_template: form_template, position: 1, field_type: 'text')
      create(:form_template_field, form_template: form_template, position: 2, field_type: 'textarea')
      create(:form_template_field, form_template: form_template, position: 3, field_type: 'email')
    end

    it 'cria form_answers para todos os fields do template' do
      response = create(:form_response, form: form, user: student)
      
      response.build_answers_for_fields
      
      expect(response.form_answers.count).to eq(3)
    end

    it 'cria answers na ordem correta (por position)' do
      response = create(:form_response, form: form, user: student)
      
      response.build_answers_for_fields
      
      answers = response.form_answers.includes(:form_template_field).sort_by { |a| a.form_template_field.position }
      expect(answers.map { |a| a.form_template_field.field_type }).to eq(['text', 'textarea', 'email'])
    end

    it 'não duplica answers se já existem' do
      response = create(:form_response, form: form, user: student)
      
      # Primeira chamada
      response.build_answers_for_fields
      first_count = response.form_answers.count
      
      # Segunda chamada
      response.build_answers_for_fields
      
      expect(response.form_answers.count).to eq(first_count)
    end

    it 'inicializa answers com valor vazio' do
      response = create(:form_response, form: form, user: student)
      
      response.build_answers_for_fields
      
      expect(response.form_answers.all? { |a| a.answer.blank? }).to be true
    end

    it 'salva a resposta após criar answers' do
      response = build(:form_response, form: form, user: student)
      
      response.save
      response.build_answers_for_fields
      
      expect(response.form_answers.count).to eq(3)
      expect(FormResponse.find(response.id).form_answers.count).to eq(3)
    end

    it 'não salva se resposta não foi persistida' do
      response = build(:form_response, form: form, user: student)
      
      response.build_answers_for_fields
      
      expect(response.persisted?).to be false
    end
  end

  describe '#submit!' do
    it 'marca resposta como submetida' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      
      expect(response.submitted_at).to be_nil
      expect(response.completed?).to be false
      
      response.submit!
      
      expect(response.submitted_at).not_to be_nil
      expect(response.completed?).to be true
    end

    it 'atualiza submitted_at com horário atual' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      
      before_submit = Time.current
      response.submit!
      after_submit = Time.current
      
      expect(response.submitted_at).to be_between(before_submit, after_submit)
    end

    it 'persiste submitted_at no banco' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      
      response.submit!
      
      reloaded = FormResponse.find(response.id)
      expect(reloaded.submitted_at).not_to be_nil
      expect(reloaded.completed?).to be true
    end

    it 'pode ser chamado múltiplas vezes' do
      response = create(:form_response, form: form, user: student, submitted_at: nil)
      
      first_submit = response.submit!
      second_submit = response.submit!
      
      expect(second_submit).to be true
      expect(response.completed?).to be true
    end
  end
end
