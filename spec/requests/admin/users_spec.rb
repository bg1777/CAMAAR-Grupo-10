require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let(:admin) { create(:user, role: :admin, password: 'password123', password_confirmation: 'password123') }
  let(:student) { create(:user, role: :user, password: 'password123', password_confirmation: 'password123') }
  let(:user_to_test) { create(:user, role: :user, name: 'João Silva', email: 'joao@example.com', password: 'password123', password_confirmation: 'password123') }

  def admin_login
    post user_session_path, params: {
      user: { email: admin.email, password: 'password123' }
    }
  end

  def student_login
    post user_session_path, params: {
      user: { email: student.email, password: 'password123' }
    }
  end

  describe 'Authentication and Authorization' do
    describe 'GET /admin/users' do
      it 'redireciona para login se não autenticado' do
        get admin_users_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redireciona se usuário não é admin' do
        student_login
        get admin_users_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado!')
      end
    end
  end

  describe 'GET /admin/users (index)' do
    before { admin_login }

    it 'retorna status sucesso' do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end

    it 'lista todos os usuários' do
      user1 = create(:user, role: :user, name: 'User 1')
      user2 = create(:user, role: :user, name: 'User 2')
      get admin_users_path
      expect(response.body).to include(user1.name)
      expect(response.body).to include(user2.name)
    end
  end

  describe 'GET /admin/users/:id (show)' do
    before { admin_login }

    it 'retorna status sucesso' do
      get admin_user_path(user_to_test)
      expect(response).to have_http_status(:success)
    end

    it 'mostra o usuário correto' do
      get admin_user_path(user_to_test)
      expect(response.body).to include(user_to_test.name)
    end

    it 'retorna 404 para usuário inexistente' do
      get admin_user_path(999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /admin/users/:id/edit' do
    before { admin_login }

    it 'retorna status sucesso' do
      get edit_admin_user_path(user_to_test)
      expect(response).to have_http_status(:success)
    end

    it 'carrega o usuário correto' do
      get edit_admin_user_path(user_to_test)
      expect(response.body).to include(user_to_test.name)
    end

    it 'renderiza o formulário de edição' do
      get edit_admin_user_path(user_to_test)
      expect(response.body).to include('form')
    end
  end

  describe 'PATCH/PUT /admin/users/:id (update)' do
    before { admin_login }

    context 'com parâmetros válidos' do
      it 'atualiza o usuário' do
        patch admin_user_path(user_to_test), params: { user: { name: 'Novo Nome' } }
        user_to_test.reload
        expect(user_to_test.name).to eq('Novo Nome')
      end

      it 'redireciona para a lista de usuários' do
        patch admin_user_path(user_to_test), params: { user: { name: 'Novo Nome' } }
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq('Usuário atualizado com sucesso')
      end

      it 'atualiza email' do
        patch admin_user_path(user_to_test), params: { user: { email: 'newemail@example.com' } }
        user_to_test.reload
        expect(user_to_test.email).to eq('newemail@example.com')
      end

      it 'atualiza role' do
        patch admin_user_path(user_to_test), params: { user: { role: 'admin' } }
        user_to_test.reload
        expect(user_to_test.role).to eq('admin')
      end
    end

    context 'com parâmetros inválidos' do
      it 'não atualiza sem nome' do
        original_name = user_to_test.name
        patch admin_user_path(user_to_test), params: { user: { name: '' } }
        user_to_test.reload
        expect(user_to_test.name).to eq(original_name)
      end

      it 'renderiza edit com status 422' do
        patch admin_user_path(user_to_test), params: { user: { name: '' } }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /admin/users/:id (destroy)' do
    before { admin_login }

    it 'deleta o usuário' do
      user_to_delete = create(:user, role: :user)
      expect {
        delete admin_user_path(user_to_delete)
      }.to change(User, :count).by(-1)
    end

    it 'redireciona para a lista de usuários' do
      delete admin_user_path(user_to_test)
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('Usuário deletado com sucesso')
    end
  end
end