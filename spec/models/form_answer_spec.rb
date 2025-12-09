# spec/models/form_answer_spec.rb

require 'rails_helper'

RSpec.describe FormAnswer, type: :model do
  let(:user) { create(:user, role: :admin) }
  let(:student) { create(:user, role: :user) }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template, user: user) }
  let(:form) { create(:form, form_template: form_template, klass: klass) }
  let(:field) { create(:form_template_field, form_template: form_template, field_type: 'text', position: 1) }
  let(:form_response) { create(:form_response, form: form, user: student) }
  let(:form_answer) { create(:form_answer, form_response: form_response, form_template_field: field) }

  describe 'associations' do
    it { is_expected.to belong_to(:form_response) }
    it { is_expected.to belong_to(:form_template_field) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:form_response_id) }
    it { is_expected.to validate_presence_of(:form_template_field_id) }
    it { is_expected.to validate_presence_of(:answer) }
  end

  describe '#create' do
    it 'cria resposta válida' do
      expect {
        create(:form_answer, 
               form_response: form_response, 
               form_template_field: field,
               answer: 'Resposta do aluno')
      }.to change(FormAnswer, :count).by(1)
    end

    it 'não cria answer sem form_response' do
      answer = build(:form_answer, 
                     form_response: nil, 
                     form_template_field: field)
      expect(answer).not_to be_valid
    end

    it 'não cria answer sem form_template_field' do
      answer = build(:form_answer, 
                     form_response: form_response, 
                     form_template_field: nil)
      expect(answer).not_to be_valid
    end

    it 'não cria answer sem resposta' do
      answer = build(:form_answer, 
                     form_response: form_response, 
                     form_template_field: field,
                     answer: nil)
      expect(answer).not_to be_valid
    end
  end

  describe 'resposta de diferentes tipos de campo' do
    it 'pode armazenar resposta de campo text' do
      text_field = create(:form_template_field, 
                          form_template: form_template, 
                          field_type: 'text', 
                          position: 1)
      answer = create(:form_answer, 
                      form_response: form_response, 
                      form_template_field: text_field,
                      answer: 'Resposta simples')
      
      expect(answer.answer).to eq('Resposta simples')
    end

    it 'pode armazenar resposta de campo textarea' do
      textarea_field = create(:form_template_field, 
                              form_template: form_template, 
                              field_type: 'textarea', 
                              position: 1)
      long_answer = 'Esta é uma resposta muito longa que pode conter múltiplas linhas'
      answer = create(:form_answer, 
                      form_response: form_response, 
                      form_template_field: textarea_field,
                      answer: long_answer)
      
      expect(answer.answer).to eq(long_answer)
    end

    it 'pode armazenar resposta de campo email' do
      email_field = create(:form_template_field, 
                           form_template: form_template, 
                           field_type: 'email', 
                           position: 1)
      answer = create(:form_answer, 
                      form_response: form_response, 
                      form_template_field: email_field,
                      answer: 'student@example.com')
      
      expect(answer.answer).to eq('student@example.com')
    end

    it 'pode armazenar resposta de campo number' do
      number_field = create(:form_template_field, 
                            form_template: form_template, 
                            field_type: 'number', 
                            position: 1)
      answer = create(:form_answer, 
                      form_response: form_response, 
                      form_template_field: number_field,
                      answer: '42')
      
      expect(answer.answer).to eq('42')
    end

    it 'pode armazenar resposta de campo multiple_choice' do
      choice_field = create(:form_template_field, 
                            form_template: form_template, 
                            field_type: 'multiple_choice', 
                            position: 1,
                            options: ['Opção A', 'Opção B', 'Opção C'])
      answer = create(:form_answer, 
                      form_response: form_response, 
                      form_template_field: choice_field,
                      answer: 'Opção B')
      
      expect(answer.answer).to eq('Opção B')
    end
  end
end