# spec/models/form_template_spec.rb

require 'rails_helper'

RSpec.describe FormTemplate, type: :model do
  let(:user) { create(:user, role: :admin) }
  let(:form_template) { create(:form_template, user: user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:form_template_fields).dependent(:destroy) }
    it { is_expected.to have_many(:forms).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe '#create' do
    it 'cria um template válido' do
      expect {
        create(:form_template, user: user)
      }.to change(FormTemplate, :count).by(1)
    end

    it 'não cria template sem nome' do
      template = build(:form_template, name: nil, user: user)
      expect(template).not_to be_valid
    end

    it 'não cria template sem descrição' do
      template = build(:form_template, description: nil, user: user)
      expect(template).not_to be_valid
    end

    it 'não cria template sem user' do
      template = build(:form_template, user: nil)
      expect(template).not_to be_valid
    end
  end

  describe '#accepts_nested_attributes_for' do
    it 'permite criar fields aninhados' do
      template = create(:form_template, user: user)
      template.form_template_fields.create!(
        field_type: 'text',
        label: 'Nome Completo',
        required: true,
        position: 1
      )

      expect(template.form_template_fields.count).to eq(1)
    end
  end
end