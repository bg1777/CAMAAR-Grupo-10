# spec/services/import_service_spec.rb

require 'rails_helper'

RSpec.describe ImportService, type: :service do
  let(:temp_dir) { Rails.root.join('tmp', 'test_imports') }

  before do
    FileUtils.mkdir_p(temp_dir) unless Dir.exist?(temp_dir)
  end

  after do
    FileUtils.rm_rf(temp_dir) if Dir.exist?(temp_dir)
  end

  describe '#import_klasses' do
    context 'com arquivo JSON válido' do
      let(:file_path) { temp_dir.join('valid_klasses.json') }

      before do
        File.write(file_path, JSON.generate([
          {
            "code" => "CIC0097",
            "name" => "BANCOS DE DADOS",
            "class" => {
              "classCode" => "TA",
              "semester" => "2021.2",
              "time" => "35T45"
            },
            "dicente" => [
              {
                "nome" => "Ana Clara Jordao Perna",
                "curso" => "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula" => "190084006",
                "usuario" => "190084006",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "acjpjvjp@gmail.com"
              },
              {
                "nome" => "Andre Carvalho de Roure",
                "curso" => "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula" => "200033522",
                "usuario" => "200033522",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "andrecarvalhoroure@gmail.com"
              }
            ]
          }
        ]))
      end

      it 'importa uma turma com sucesso' do
        service = ImportService.new(file_path)
        result = service.import_klasses

        expect(result[:success]).to be true
        expect(result[:imported]).to eq(1)
        expect(result[:errors]).to be_empty
      end

      it 'cria a turma corretamente' do
        service = ImportService.new(file_path)
        service.import_klasses

        klass = Klass.find_by(code: 'CIC0097')

        expect(klass).to be_present
        expect(klass.name).to eq('BANCOS DE DADOS')
        expect(klass.semester).to eq('2021.2')
      end

      it 'cria os usuários estudantes' do
        service = ImportService.new(file_path)
        service.import_klasses

        expect(User.count).to eq(2)
        expect(User.find_by(email: 'acjpjvjp@gmail.com')).to be_present
        expect(User.find_by(email: 'andrecarvalhoroure@gmail.com')).to be_present
      end

      it 'cria as associações ClassMember' do
        service = ImportService.new(file_path)
        service.import_klasses

        klass = Klass.find_by(code: 'CIC0097')
        expect(klass.class_members.count).to eq(2)
        expect(klass.class_members.all? { |cm| cm.role == 'dicente' }).to be true
      end

      it 'popula campos do usuário corretamente' do
        service = ImportService.new(file_path)
        service.import_klasses

        user = User.find_by(email: 'acjpjvjp@gmail.com')

        expect(user.name).to eq('Ana Clara Jordao Perna')
        expect(user.matricula).to eq('190084006')
        expect(user.curso).to eq('CIÊNCIA DA COMPUTAÇÃO/CIC')
        expect(user.formacao).to eq('graduando')
        expect(user.ocupacao).to eq('dicente')
      end
    end

    context 'com múltiplas turmas' do
      let(:file_path) { temp_dir.join('multiple_klasses.json') }

      before do
        File.write(file_path, JSON.generate([
          {
            "code" => "CIC0097",
            "name" => "BANCOS DE DADOS",
            "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" },
            "dicente" => [
              {
                "nome" => "Student 1",
                "curso" => "CIC",
                "matricula" => "001",
                "usuario" => "001",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "student1@example.com"
              }
            ]
          },
          {
            "code" => "CIC0105",
            "name" => "ENGENHARIA DE SOFTWARE",
            "class" => { "classCode" => "TB", "semester" => "2021.2", "time" => "35M12" },
            "dicente" => [
              {
                "nome" => "Student 2",
                "curso" => "CIC",
                "matricula" => "002",
                "usuario" => "002",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "student2@example.com"
              }
            ]
          }
        ]))
      end

      it 'importa múltiplas turmas' do
        service = ImportService.new(file_path)
        result = service.import_klasses

        expect(result[:imported]).to eq(2)
        expect(Klass.count).to eq(2)
      end
    end

    context 'com arquivo JSON inválido' do
      let(:file_path) { temp_dir.join('invalid.json') }

      before do
        File.write(file_path, 'invalid json {')
      end

      it 'retorna erro' do
        service = ImportService.new(file_path)
        result = service.import_klasses

        expect(result[:success]).to be false
        expect(result[:error]).to include('Erro ao ler arquivo JSON')
      end
    end

    context 'com arquivo não encontrado' do
      let(:file_path) { temp_dir.join('nonexistent.json') }

      it 'retorna erro' do
        service = ImportService.new(file_path)
        result = service.import_klasses

        expect(result[:success]).to be false
        expect(result[:error]).to include('Arquivo não encontrado')
      end
    end

    context 'quando estudante já existe' do
      let(:file_path) { temp_dir.join('existing_student.json') }

      before do
        # Criar usuário pré-existente
        create(:user, email: 'existing@example.com', name: 'Existing Student')

        File.write(file_path, JSON.generate([
          {
            "code" => "CIC0097",
            "name" => "BANCOS DE DADOS",
            "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" },
            "dicente" => [
              {
                "nome" => "New Name",
                "curso" => "CIC",
                "matricula" => "999",
                "usuario" => "999",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "existing@example.com"
              }
            ]
          }
        ]))
      end

      it 'reutiliza o usuário existente' do
        expect(User.count).to eq(1)

        service = ImportService.new(file_path)
        service.import_klasses

        expect(User.count).to eq(1)
        expect(User.find_by(email: 'existing@example.com').name).to eq('Existing Student')
      end

      it 'cria ClassMember para usuário existente' do
        service = ImportService.new(file_path)
        service.import_klasses

        user = User.find_by(email: 'existing@example.com')
        klass = Klass.find_by(code: 'CIC0097')

        expect(ClassMember.find_by(user: user, klass: klass)).to be_present
      end
    end

    context 'quando estudante já está na turma' do
      let(:file_path) { temp_dir.join('duplicate_enrollment.json') }

      before do
        File.write(file_path, JSON.generate([
          {
            "code" => "CIC0097",
            "name" => "BANCOS DE DADOS",
            "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" },
            "dicente" => [
              {
                "nome" => "Student",
                "curso" => "CIC",
                "matricula" => "001",
                "usuario" => "001",
                "formacao" => "graduando",
                "ocupacao" => "dicente",
                "email" => "student@example.com"
              }
            ]
          }
        ]))
      end
    end
  end
end