# spec/models/form_template_field_spec.rb

require 'rails_helper'

RSpec.describe FormTemplateField, type: :model do
  let(:user) { create(:user, role: :admin) }
  let(:form_template) { create(:form_template, user: user) }
  let(:field) do
    create(:form_template_field, 
           form_template: form_template,
           field_type: 'text',
           label: 'Nome',
           position: 1)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:form_template) }
    it { is_expected.to have_many(:form_answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:field_type) }
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_presence_of(:position) }
    it { is_expected.to validate_presence_of(:form_template_id) }
  end

  describe 'field_type validation' do
    it 'aceita field_type válido' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'text')
      expect(field).to be_valid
    end

    it 'rejeita field_type inválido' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'invalid')
      expect(field).not_to be_valid
    end

    it 'aceita todos os tipos válidos' do
      valid_types = %w(text textarea number email multiple_choice)
      valid_types.each do |type|
        field = build(:form_template_field, 
                      form_template: form_template, 
                      field_type: type)
        expect(field).to be_valid
      end
    end
  end

  describe '#create' do
    it 'cria field com sucesso' do
      expect {
        create(:form_template_field, 
               form_template: form_template, 
               field_type: 'text')
      }.to change(FormTemplateField, :count).by(1)
    end

    it 'não cria field sem label' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    label: nil)
      expect(field).not_to be_valid
    end

    it 'não cria field sem position' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    position: nil)
      expect(field).not_to be_valid
    end
  end
end