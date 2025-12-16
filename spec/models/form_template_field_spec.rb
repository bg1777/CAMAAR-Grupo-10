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

  describe 'field_type validation' do
    it 'aceita field_type válido' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'text')
      expect(field).to be_valid
    end

    it 'rejeita field_type inválido' do
      # Usar attributes para evitar erro do enum
      field = build(:form_template_field, 
                    form_template: form_template)
      # Manualmente definir field_type inválido
      allow(field).to receive(:field_type).and_return('invalid')
      field.instance_variable_set(:@field_type, 'invalid')
      
      expect {
        field.validate
      }.not_to raise_error
      
      # Alternatively, test it properly
      field_invalid = FormTemplateField.new(
        form_template: form_template,
        label: 'Test',
        position: 1,
        field_type: 'invalid'
      )
      expect(field_invalid).not_to be_valid
      expect(field_invalid.errors[:field_type]).to be_present
    end

    it 'aceita todos os tipos válidos' do
      valid_types = %w(text textarea email number date select radio checkbox)
      valid_types.each do |type|
        field = build(:form_template_field, 
                      form_template: form_template, 
                      field_type: type,
                      options: type.in?(['select', 'radio', 'checkbox']) ? '["option1"]' : nil)
        expect(field).to be_valid, "#{type} deveria ser válido, mas teve erros: #{field.errors.full_messages.join(', ')}"
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

    it 'não cria field sem form_template_id' do
      field = build(:form_template_field, 
                    form_template_id: nil, 
                    label: 'Test',
                    field_type: 'text',
                    position: 1)
      expect(field).not_to be_valid
    end
  end

  describe 'options validation' do
    it 'requer options para select fields' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'select',
                    label: 'Test',
                    position: 1,
                    options: nil)
      expect(field).not_to be_valid
      expect(field.errors[:options]).to be_present
    end

    it 'requer options para radio fields' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'radio',
                    label: 'Test',
                    position: 1,
                    options: nil)
      expect(field).not_to be_valid
      expect(field.errors[:options]).to be_present
    end

    it 'requer options para checkbox fields' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'checkbox',
                    label: 'Test',
                    position: 1,
                    options: nil)
      expect(field).not_to be_valid
      expect(field.errors[:options]).to be_present
    end

    it 'não requer options para text fields' do
      field = build(:form_template_field, 
                    form_template: form_template, 
                    field_type: 'text',
                    label: 'Test',
                    position: 1,
                    options: nil)
      expect(field).to be_valid
    end
  end

  describe '#requires_options?' do
    it 'retorna true para select' do
      field = build(:form_template_field, field_type: 'select', options: '["opt1"]')
      expect(field.send(:requires_options?)).to be_truthy
    end

    it 'retorna true para radio' do
      field = build(:form_template_field, field_type: 'radio', options: '["opt1"]')
      expect(field.send(:requires_options?)).to be_truthy
    end

    it 'retorna true para checkbox' do
      field = build(:form_template_field, field_type: 'checkbox', options: '["opt1"]')
      expect(field.send(:requires_options?)).to be_truthy
    end

    it 'retorna false para text' do
      field = build(:form_template_field, field_type: 'text')
      expect(field.send(:requires_options?)).to be_falsey
    end
  end

  describe 'VALID_FIELD_TYPES constant' do
    it 'contém todos os tipos suportados' do
      expect(FormTemplateField::VALID_FIELD_TYPES).to eq(
        %w(text textarea email number date select radio checkbox)
      )
    end
  end
end
