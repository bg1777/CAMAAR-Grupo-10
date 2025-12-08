# spec/models/class_member_spec.rb

require 'rails_helper'

RSpec.describe ClassMember, type: :model do
  describe 'validações' do
    it { should validate_presence_of(:role) }
    
    it 'não permite role inválido' do
      user = create(:user)
      klass = create(:klass)
      
      class_member = build(:class_member, user: user, klass: klass, role: 'invalido')
      
      expect(class_member).not_to be_valid
    end
    
    it 'não permite mesmo usuário em mesma turma duas vezes' do
      user = create(:user)
      klass = create(:klass)
      
      create(:class_member, user: user, klass: klass, role: 'dicente')
      
      duplicate = build(:class_member, user: user, klass: klass, role: 'dicente')
      
      expect(duplicate).not_to be_valid
    end
  end

  describe 'associações' do
    it { should belong_to(:user) }
    it { should belong_to(:klass) }
  end

  describe 'roles válidos' do
    let(:user) { create(:user) }
    let(:klass) { create(:klass) }
    
    it 'permite role dicente' do
      class_member = build(:class_member, user: user, klass: klass, role: 'dicente')
      
      expect(class_member).to be_valid
    end
    
    it 'permite role docente' do
      class_member = build(:class_member, user: user, klass: klass, role: 'docente')
      
      expect(class_member).to be_valid
    end
  end
end