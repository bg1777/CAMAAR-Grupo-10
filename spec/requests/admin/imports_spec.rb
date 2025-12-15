require 'rails_helper'

RSpec.describe 'Admin::Imports', type: :request do
  include Warden::Test::Helpers

  let(:admin) { create(:user, role: :admin) }
  let(:student) { create(:user, role: :user) }

  def login_as_admin
    login_as(admin, scope: :user)
  end

  def login_as_student
    login_as(student, scope: :user)
  end

  after { Warden.test_reset! }

  def create_valid_json_file
    valid_data = [
      {
        "code" => "CIC001",
        "name" => "Cálculo I",
        "class" => {
          "semester" => "2024.1",
          "classCode" => "01",
          "time" => "08:00-10:00"
        },
        "dicente" => [
          {
            "nome" => "João Silva",
            "email" => "joao@example.com",
            "matricula" => "202401001",
            "curso" => "Engenharia",
            "formacao" => "Graduação",
            "ocupacao" => "Estudante"
          },
          {
            "nome" => "Maria Santos",
            "email" => "maria@example.com",
            "matricula" => "202401002",
            "curso" => "Engenharia",
            "formacao" => "Graduação",
            "ocupacao" => "Estudante"
          }
        ]
      }
    ]

    Tempfile.open(['import', '.json']) do |file|
      file.write(JSON.generate(valid_data))
      file.rewind
      fixture_file_upload(file.path, 'application/json')
    end
  end

  def create_invalid_json_file
    Tempfile.open(['import', '.json']) do |file|
      file.write('{ invalid json }')
      file.rewind
      fixture_file_upload(file.path, 'application/json')
    end
  end

  def create_wrong_extension_file
    Tempfile.open(['import', '.txt']) do |file|
      file.write('some content')
      file.rewind
      fixture_file_upload(file.path, 'text/plain')
    end
  end

  describe 'Authentication and Authorization' do
    describe 'GET /admin/imports (não autenticado)' do
      it 'redireciona para login se não autenticado' do
        get admin_imports_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /admin/imports (student)' do
      it 'redireciona se usuário não é admin' do
        login_as_student
        get admin_imports_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado!')
      end
    end
  end

  describe 'GET /admin/imports (index)' do
    before { login_as_admin }

    it 'retorna status sucesso' do
      get admin_imports_path
      expect(response).to have_http_status(:success)
    end

    it 'exibe total de turmas' do
      create_list(:klass, 3)
      get admin_imports_path
      expect(response.body).to include('3')
    end

    it 'exibe total de estudantes' do
      create_list(:user, 5, role: :user)
      get admin_imports_path
      expect(User.where(role: :user).count).to eq(5)
    end

    it 'renderiza formulário de upload' do
      get admin_imports_path
      expect(response.body).to include('file')
    end
  end

  describe 'POST /admin/imports/import_klasses' do
    before { login_as_admin }

    context 'sem arquivo' do
      it 'redireciona com alerta' do
        post '/admin/imports/import_klasses', params: {}
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to eq('Por favor, selecione um arquivo')
      end

      it 'não cria turmas' do
        expect {
          post '/admin/imports/import_klasses', params: {}
        }.not_to change(Klass, :count)
      end
    end

    context 'com arquivo de extensão errada' do
      it 'redireciona com alerta' do
        file = create_wrong_extension_file
        post '/admin/imports/import_klasses', params: { file: file }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to include('Por favor, envie um arquivo JSON válido')
      end

      it 'não cria turmas' do
        file = create_wrong_extension_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.not_to change(Klass, :count)
      end
    end

    context 'com arquivo JSON válido' do
      it 'importa turma com sucesso' do
        file = create_valid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.to change(Klass, :count).by(1)
      end

      it 'importa estudantes' do
        file = create_valid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.to change(User, :count).by(2)
      end

      it 'cria class_members para cada estudante' do
        file = create_valid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.to change(ClassMember, :count).by(2)
      end

      it 'redireciona com mensagem de sucesso' do
        file = create_valid_json_file
        post '/admin/imports/import_klasses', params: { file: file }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:notice]).to include('✅')
        expect(flash[:notice]).to include('1 turma(s) importada(s) com sucesso!')
      end

      it 'cria turma com dados corretos' do
        file = create_valid_json_file
        post '/admin/imports/import_klasses', params: { file: file }
        
        klass = Klass.last
        expect(klass.code).to eq('CIC001')
        expect(klass.name).to eq('Cálculo I')
        expect(klass.semester).to eq('2024.1')
      end

      it 'cria usuários com dados corretos' do
        file = create_valid_json_file
        post '/admin/imports/import_klasses', params: { file: file }
        
        user = User.find_by(email: 'joao@example.com')
        expect(user).to be_present
        expect(user.name).to eq('João Silva')
        expect(user.matricula).to eq('202401001')
        expect(user.role).to eq('user')
      end

      it 'cria class_members com role dicente' do
        file = create_valid_json_file
        post '/admin/imports/import_klasses', params: { file: file }
        
        klass = Klass.last
        user = User.find_by(email: 'joao@example.com')
        class_member = ClassMember.find_by(user: user, klass: klass)
        expect(class_member.role).to eq('dicente')
      end

      it 'não duplica turmas se já existem' do
        create(:klass, code: 'CIC001')
        
        file = create_valid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.not_to change(Klass, :count)
      end

      it 'não duplica usuários se já existem' do
        create(:user, email: 'joao@example.com', role: :user)
        create(:user, email: 'maria@example.com', role: :user)
        
        file = create_valid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.not_to change(User, :count)
      end

      it 'associa usuário existente à turma' do
        user = create(:user, email: 'joao@example.com', role: :user)
        file = create_valid_json_file
        
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.to change(ClassMember, :count).by(2)
        
        klass = Klass.last
        expect(klass.users).to include(user)
      end
    end

    context 'com múltiplas turmas' do
      it 'importa todas as turmas' do
        data = [
          {
            "code" => "MAT001",
            "name" => "Matemática",
            "class" => { "semester" => "2024.1", "classCode" => "01", "time" => "08:00" },
            "dicente" => []
          },
          {
            "code" => "FIS001",
            "name" => "Física",
            "class" => { "semester" => "2024.1", "classCode" => "02", "time" => "10:00" },
            "dicente" => []
          }
        ]

        Tempfile.open(['import', '.json']) do |file|
          file.write(JSON.generate(data))
          file.rewind
          uploaded_file = fixture_file_upload(file.path, 'application/json')
          
          expect {
            post '/admin/imports/import_klasses', params: { file: uploaded_file }
          }.to change(Klass, :count).by(2)
        end
      end

      it 'mostra contagem de turmas importadas' do
        data = [
          {
            "code" => "MAT001",
            "name" => "Matemática",
            "class" => { "semester" => "2024.1", "classCode" => "01", "time" => "08:00" },
            "dicente" => []
          },
          {
            "code" => "FIS001",
            "name" => "Física",
            "class" => { "semester" => "2024.1", "classCode" => "02", "time" => "10:00" },
            "dicente" => []
          }
        ]

        Tempfile.open(['import', '.json']) do |file|
          file.write(JSON.generate(data))
          file.rewind
          uploaded_file = fixture_file_upload(file.path, 'application/json')
          
          post '/admin/imports/import_klasses', params: { file: uploaded_file }
          expect(flash[:notice]).to include('2 turma(s) importada(s)')
        end
      end
    end

    context 'com JSON inválido' do
      it 'redireciona com mensagem de erro' do
        file = create_invalid_json_file
        post '/admin/imports/import_klasses', params: { file: file }
        expect(response).to redirect_to(admin_imports_path)
        expect(flash[:alert]).to include('❌ Erro na importação')
      end

      it 'não cria turmas' do
        file = create_invalid_json_file
        expect {
          post '/admin/imports/import_klasses', params: { file: file }
        }.not_to change(Klass, :count)
      end
    end

    context 'com erro ao salvar usuário' do
      it 'reporta erro e continua importação' do
        # Dados com email inválido para forçar erro de validação
        invalid_data = [
          {
            "code" => "CIC001",
            "name" => "Cálculo I",
            "class" => {
              "semester" => "2024.1",
              "classCode" => "01",
              "time" => "08:00-10:00"
            },
            "dicente" => [
              {
                "nome" => "João Silva",
                "email" => "invalid-email",
                "matricula" => "202401001",
                "curso" => "Engenharia",
                "formacao" => "Graduação",
                "ocupacao" => "Estudante"
              }
            ]
          }
        ]

        Tempfile.open(['import', '.json']) do |file|
          file.write(JSON.generate(invalid_data))
          file.rewind
          uploaded_file = fixture_file_upload(file.path, 'application/json')
          
          post '/admin/imports/import_klasses', params: { file: uploaded_file }
          expect(response).to redirect_to(admin_imports_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
