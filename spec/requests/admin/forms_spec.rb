# spec/requests/admin/forms_spec.rb

require 'rails_helper'

RSpec.describe 'Admin::Forms', type: :request do
  let(:admin) { create(:user, role: :admin, password: 'password123', password_confirmation: 'password123') }
  let(:student) { create(:user, role: :user, password: 'password123', password_confirmation: 'password123') }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template, user: admin) }
  let(:form) { create(:form, form_template: form_template, klass: klass) }

  # Helper para fazer login em request tests
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
    describe 'GET /admin/forms' do
      it 'redireciona para login se não autenticado' do
        get admin_forms_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redireciona se usuário não é admin' do
        student_login
        get admin_forms_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado!')
      end
    end
  end

  describe 'GET /admin/forms (index)' do
    before { admin_login }

    it 'retorna status sucesso' do
      get admin_forms_path
      expect(response).to have_http_status(:success)
    end

    it 'lista todos os formulários' do
      form1 = create(:form, form_template: form_template, klass: klass)
      form2 = create(:form, form_template: form_template, klass: klass)

      get admin_forms_path

      expect(response.body).to include(form1.title)
      expect(response.body).to include(form2.title)
    end

    it 'ordena formulários por data de criação (decrescente)' do
      older_form = create(:form, form_template: form_template, klass: klass, created_at: 2.days.ago)
      newer_form = create(:form, form_template: form_template, klass: klass, created_at: 1.day.ago)

      get admin_forms_path

      expect(response.body.index(newer_form.title)).to be < response.body.index(older_form.title)
    end
  end

  describe 'GET /admin/forms/:id (show)' do
    before { admin_login }

    it 'retorna status sucesso' do
      get admin_form_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'mostra o formulário correto' do
      get admin_form_path(form)
      expect(response.body).to include(form.title)
    end

    it 'conta respostas pendentes' do
      student1 = create(:user, role: :user)
      student2 = create(:user, role: :user)
      create(:class_member, user: student1, klass: klass, role: 'dicente')
      create(:class_member, user: student2, klass: klass, role: 'dicente')
      create(:form_response, form: form, user: student1)

      get admin_form_path(form)

      expect(response.body).to include(form.title)
    end

    it 'retorna 404 para formulário inexistente' do
      get admin_form_path(999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /admin/forms/new' do
    before { admin_login }

    it 'retorna status sucesso' do
      get new_admin_form_path
      expect(response).to have_http_status(:success)
    end

    it 'renderiza o formulário novo' do
      get new_admin_form_path
      expect(response.body).to include('form')
    end
  end

  describe 'POST /admin/forms (create)' do
    before { admin_login }

    context 'com parâmetros válidos' do
      it 'cria um novo formulário' do
        expect {
          post admin_forms_path, params: {
            form: {
              form_template_id: form_template.id,
              klass_id: klass.id,
              title: 'Novo Formulário',
              description: 'Descrição do formulário',
              due_date: 1.week.from_now
            }
          }
        }.to change(Form, :count).by(1)
      end

      it 'redireciona para a página do formulário criado' do
        post admin_forms_path, params: {
          form: {
            form_template_id: form_template.id,
            klass_id: klass.id,
            title: 'Novo Formulário',
            description: 'Descrição',
            due_date: 1.week.from_now
          }
        }

        expect(response).to redirect_to(admin_form_path(Form.last))
        expect(flash[:notice]).to eq('Formulário criado com sucesso!')
      end

      it 'define status como draft' do
        post admin_forms_path, params: {
          form: {
            form_template_id: form_template.id,
            klass_id: klass.id,
            title: 'Novo Formulário',
            description: 'Descrição',
            due_date: 1.week.from_now
          }
        }

        expect(Form.last.draft?).to be true
      end
    end

    context 'com parâmetros inválidos' do
      it 'não cria um formulário sem template' do
        expect {
          post admin_forms_path, params: {
            form: {
              form_template_id: nil,
              klass_id: klass.id,
              title: 'Novo Formulário'
            }
          }
        }.not_to change(Form, :count)
      end
    end
  end

  describe 'GET /admin/forms/:id/edit' do
    before { admin_login }

    it 'retorna status sucesso' do
      get edit_admin_form_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'carrega o formulário correto' do
      get edit_admin_form_path(form)
      expect(response.body).to include(form.title)
    end

    it 'renderiza o formulário de edição' do
      get edit_admin_form_path(form)
      expect(response.body).to include('form')
    end
  end

  describe 'PATCH/PUT /admin/forms/:id (update)' do
    before { admin_login }

    context 'com parâmetros válidos' do
      it 'atualiza o formulário' do
        patch admin_form_path(form), params: {
          form: {
            title: 'Novo Título'
          }
        }

        form.reload
        expect(form.title).to eq('Novo Título')
      end

      it 'redireciona para a página do formulário' do
        patch admin_form_path(form), params: {
          form: {
            title: 'Novo Título'
          }
        }

        expect(response).to redirect_to(admin_form_path(form))
        expect(flash[:notice]).to eq('Formulário atualizado com sucesso!')
      end

      it 'atualiza descrição' do
        patch admin_form_path(form), params: {
          form: {
            description: 'Nova descrição'
          }
        }

        form.reload
        expect(form.description).to eq('Nova descrição')
      end

      it 'atualiza due_date' do
        new_date = 2.weeks.from_now
        patch admin_form_path(form), params: {
          form: {
            due_date: new_date
          }
        }

        form.reload
        expect(form.due_date.to_date).to eq(new_date.to_date)
      end
    end

    context 'com parâmetros inválidos' do
      it 'não atualiza sem título' do
        original_title = form.title
        patch admin_form_path(form), params: {
          form: {
            title: ''
          }
        }

        form.reload
        expect(form.title).to eq(original_title)
      end

      it 'renderiza com status 422' do
        patch admin_form_path(form), params: {
          form: {
            title: ''
          }
        }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /admin/forms/:id (destroy)' do
    before { admin_login }

    it 'deleta o formulário' do
      form_to_delete = create(:form, form_template: form_template, klass: klass)

      expect {
        delete admin_form_path(form_to_delete)
      }.to change(Form, :count).by(-1)
    end

    it 'redireciona para a lista de formulários' do
      delete admin_form_path(form)
      expect(response).to redirect_to(admin_forms_path)
      expect(flash[:notice]).to eq('Formulário deletado com sucesso!')
    end

    it 'deleta as respostas associadas' do
      student1 = create(:user, role: :user)
      create(:form_response, form: form, user: student1)

      expect {
        delete admin_form_path(form)
      }.to change(FormResponse, :count).by(-1)
    end
  end

  describe 'PATCH /admin/forms/:id/publish' do
    before { admin_login }

    it 'publica o formulário' do
      patch publish_admin_form_path(form)

      form.reload
      expect(form.published?).to be true
    end

    it 'redireciona para a página do formulário' do
      patch publish_admin_form_path(form)
      expect(response).to redirect_to(admin_form_path(form))
      expect(flash[:notice]).to eq('Formulário publicado com sucesso!')
    end

    it 'muda status de draft para published' do
      expect(form.draft?).to be true
      patch publish_admin_form_path(form)
      form.reload
      expect(form.published?).to be true
    end
  end

  describe 'PATCH /admin/forms/:id/close' do
    before { admin_login }

    it 'fecha o formulário' do
      form.update(status: :published)
      patch close_admin_form_path(form)

      form.reload
      expect(form.closed?).to be true
    end

    it 'redireciona para a página do formulário' do
      form.update(status: :published)
      patch close_admin_form_path(form)
      expect(response).to redirect_to(admin_form_path(form))
      expect(flash[:notice]).to eq('Formulário fechado com sucesso!')
    end

    it 'muda status de published para closed' do
      form.update(status: :published)
      expect(form.published?).to be true
      patch close_admin_form_path(form)
      form.reload
      expect(form.closed?).to be true
    end
  end

  describe 'GET /admin/forms/:id/view_response' do
    before { admin_login }

    it 'retorna status sucesso' do
      student_user = create(:user, role: :user)
      form_response = create(:form_response, form: form, user: student_user, submitted_at: Time.current)

      get view_response_admin_form_path(form, response_id: form_response.id)
      expect(response).to have_http_status(:success)
    end

    it 'retorna 404 para resposta inexistente' do
      get view_response_admin_form_path(form, response_id: 999)
      expect(response).to have_http_status(:not_found)
    end
  end
end