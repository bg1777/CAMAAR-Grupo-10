require 'rails_helper'

RSpec.describe 'Student::Forms', type: :request do
  # Inclui helpers do Warden para login direto
  include Warden::Test::Helpers

  let(:student) { create(:user, role: :user, password: 'password123', password_confirmation: 'password123') }
  let(:admin) { create(:user, role: :admin, password: 'password123', password_confirmation: 'password123') }
  let(:klass) { create(:klass) }
  let(:form_template) { create(:form_template) }
  let(:form) { create(:form, form_template: form_template, klass: klass, status: :published) }

  # Helper: Login robusto com Warden
  def login_as_student
    # Garante que o estudante está na turma. Usa create! para lançar erro se falhar.
    # Tenta usar factory se existir, senão cria direto
    if FactoryBot.factories.registered?(:class_member)
      create(:class_member, klass: klass, user: student)
    else
      klass.class_members.create!(user: student)
    end
    
    login_as(student, scope: :user)
  end

  def login_as_admin
    login_as(admin, scope: :user)
  end

  # Limpar Warden após cada teste
  after { Warden.test_reset! }

  describe 'Authentication and Authorization' do
    describe 'GET /student/forms (não autenticado)' do
      it 'redireciona para login se não autenticado' do
        get student_forms_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /student/forms (admin)' do
      it 'redireciona se usuário é admin' do
        login_as_admin
        get student_forms_path
        expect(response).to redirect_to(admin_root_path)
      end
    end
  end

  describe 'GET /student/forms (index)' do
    before { login_as_student }

    it 'retorna status sucesso' do
      get student_forms_path
      expect(response).to have_http_status(:success)
    end

    it 'lista formulários pendentes' do
      pending_form = create(:form, form_template: form_template, klass: klass, status: :published)
      get student_forms_path
      expect(response.body).to include(pending_form.title)
    end

    it 'lista formulários completados' do
      completed_form = create(:form, form_template: form_template, klass: klass, status: :published)
      # Cria resposta já submetida
      create(:form_response, form: completed_form, user: student, submitted_at: Time.current)
      
      get student_forms_path
      expect(response.body).to include(completed_form.title)
    end
  end

  describe 'GET /student/forms/:id (show)' do
    before { login_as_student }

    it 'retorna status sucesso' do
      get student_form_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'mostra o formulário correto' do
      get student_form_path(form)
      expect(response.body).to include(form.title)
    end

    it 'retorna 404 para formulário inexistente' do
      get student_form_path(999)
      expect(response).to have_http_status(:not_found)
    end

    it 'redireciona se formulário não está publicado' do
      unpublished_form = create(:form, form_template: form_template, klass: klass, status: :draft)
      get student_form_path(unpublished_form)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Acesso negado a este formulário')
    end

    it 'redireciona se estudante não está na turma' do
      other_klass = create(:klass)
      other_form = create(:form, form_template: form_template, klass: other_klass, status: :published)
      get student_form_path(other_form)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Acesso negado a este formulário')
    end
  end

  describe 'GET /student/forms/:id/answer' do
    before { login_as_student }

    it 'retorna status sucesso' do
      get answer_student_form_path(form)
      expect(response).to have_http_status(:success)
    end

    it 'cria FormResponse se não existir' do
      expect {
        get answer_student_form_path(form)
      }.to change(FormResponse, :count).by(1)
    end

    it 'não duplica FormResponse na segunda vez' do
      get answer_student_form_path(form)
      expect {
        get answer_student_form_path(form)
      }.not_to change(FormResponse, :count)
    end

    it 'cria form_answers para cada campo' do
      create(:form_template_field, form_template: form_template, field_type: 'text', position: 1, label: 'Nome')
      get answer_student_form_path(form)
      
      form_response = FormResponse.last
      expect(form_response.form_answers.count).to eq(1)
    end
  end

  describe 'POST /student/forms/:id/submit_answer' do
    before { login_as_student }

    context 'com respostas válidas' do
      it 'redireciona para root com sucesso' do
        field = create(:form_template_field, form_template: form_template, field_type: 'text', position: 1, label: 'Nome')
        # Setup correto: FormResponse DEVE existir antes do submit
        form_response = create(:form_response, form: form, user: student, submitted_at: nil)
        form_answer = create(:form_answer, form_response: form_response, form_template_field: field)

        post submit_answer_student_form_path(form), params: {
          form_response: {
            form_answers_attributes: [
              { id: form_answer.id, answer: 'Resposta do estudante' }
            ]
          }
        }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Formulário respondido com sucesso!')
      end

      it 'atualiza submitted_at da resposta' do
        field = create(:form_template_field, form_template: form_template, field_type: 'text', position: 1, label: 'Nome')
        form_response = create(:form_response, form: form, user: student, submitted_at: nil)
        form_answer = create(:form_answer, form_response: form_response, form_template_field: field)

        post submit_answer_student_form_path(form), params: {
          form_response: {
            form_answers_attributes: [
              { id: form_answer.id, answer: 'Resposta do estudante' }
            ]
          }
        }

        expect(form_response.reload.submitted_at).to be_present
      end

      it 'salva as respostas' do
        field = create(:form_template_field, form_template: form_template, field_type: 'text', position: 1, label: 'Nome')
        form_response = create(:form_response, form: form, user: student, submitted_at: nil)
        form_answer = create(:form_answer, form_response: form_response, form_template_field: field)

        post submit_answer_student_form_path(form), params: {
          form_response: {
            form_answers_attributes: [
              { id: form_answer.id, answer: 'Nova resposta' }
            ]
          }
        }

        expect(form_answer.reload.answer).to eq('Nova resposta')
      end
    end

    context 'com FormResponse não encontrada' do
      it 'redireciona e exibe alerta' do
        # Não criamos form_response aqui propositalmente
        post submit_answer_student_form_path(form), params: {
          form_response: { form_answers_attributes: [] }
        }

        expect(response).to redirect_to(student_form_path(form))
        expect(flash[:alert]).to eq('Resposta não encontrada')
      end
    end

    context 'com respostas inválidas' do
      it 'redireciona para answer com alerta' do
        form_response = create(:form_response, form: form, user: student, submitted_at: nil)
        
        # Mock para forçar falha no salvamento
        allow_any_instance_of(FormResponse).to receive(:submit!).and_return(false)

        post submit_answer_student_form_path(form), params: {
          form_response: {
            form_answers_attributes: []
          }
        }

        expect(response).to redirect_to(answer_student_form_path(form))
        expect(flash[:alert]).to eq('Erro ao salvar respostas')
      end
    end
  end
end