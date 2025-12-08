# spec/models/klass_spec.rb

require 'rails_helper'

RSpec.describe Klass, type: :model do
  describe 'validações' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:semester) }
    
    it 'valida unicidade de code' do
      create(:klass, code: 'CIC0097')
      klass2 = build(:klass, code: 'CIC0097')
      
      expect(klass2).not_to be_valid
    end
  end

  describe 'associações' do
    it { should have_many(:class_members) }
    it { should have_many(:users).through(:class_members) }
  end

  describe '#students' do
    it 'retorna apenas os alunos da turma' do
      klass = create(:klass)
      student = create(:user)
      teacher = create(:user)
      
      create(:class_member, klass: klass, user: student, role: 'dicente')
      create(:class_member, klass: klass, user: teacher, role: 'docente')
      
      expect(klass.students).to include(student)
      expect(klass.students).not_to include(teacher)
      expect(klass.students.count).to eq(1)
    end
  end

  describe '#teachers' do
    it 'retorna apenas os professores da turma' do
      klass = create(:klass)
      student = create(:user)
      teacher = create(:user)
      
      create(:class_member, klass: klass, user: student, role: 'dicente')
      create(:class_member, klass: klass, user: teacher, role: 'docente')
      
      expect(klass.teachers).to include(teacher)
      expect(klass.teachers).not_to include(student)
      expect(klass.teachers.count).to eq(1)
    end
  end

  describe 'scopes' do
    it 'ordena por semestre decrescente' do
      klass1 = create(:klass, semester: '2021.1')
      klass2 = create(:klass, code: 'CIC0098', semester: '2021.2')
      
      expect(Klass.active).to eq([klass2, klass1])
    end
  end
end