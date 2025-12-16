require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  include Warden::Test::Helpers

  let(:admin) { create(:user, role: :admin) }
  let(:student) { create(:user, role: :user) }

  after { Warden.test_reset! }

  describe 'GET home#index' do
    context 'quando não autenticado' do
      it 'redireciona para login' do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redireciona para login via named route' do
        get home_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'quando autenticado como admin' do
      before { login_as(admin, scope: :user) }

      it 'redireciona para admin dashboard' do
        get root_path
        expect(response).to redirect_to(admin_root_path)
      end

      it 'retorna status redirect' do
        get root_path
        expect(response).to have_http_status(:found)
      end
    end

    context 'quando autenticado como estudante' do
      before { login_as(student, scope: :user) }

      it 'retorna status sucesso' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'retorna sucesso via named route' do
        get home_path
        expect(response).to have_http_status(:success)
      end

      it 'exibe pending forms vazios quando nenhum formulário' do
        get root_path
        expect(response.body).to be_present
        expect(response).to have_http_status(:success)
      end

      it 'exibe completed forms vazios quando nenhum respondido' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'ordena pending_forms por due_date ASC' do
        klass = create(:klass)
        form_template = create(:form_template)
        form1 = create(:form, klass: klass, form_template: form_template, status: :published, due_date: 2.days.from_now)
        form2 = create(:form, klass: klass, form_template: form_template, status: :published, due_date: 1.day.from_now)
        create(:class_member, user: student, klass: klass, role: 'dicente')

        expect(student.pending_forms).to include(form2, form1)
        expect(student.pending_forms.order(due_date: :asc)).to eq([form2, form1])
      end

      it 'ordena completed_forms por created_at DESC' do
        klass = create(:klass)
        form_template = create(:form_template)
        form1 = create(:form, klass: klass, form_template: form_template, status: :published, due_date: 1.day.ago)
        form2 = create(:form, klass: klass, form_template: form_template, status: :published, due_date: 2.days.ago)
        create(:class_member, user: student, klass: klass, role: 'dicente')

        create(:form_response, form: form1, user: student, submitted_at: 1.hour.ago)
        create(:form_response, form: form2, user: student, submitted_at: 2.hours.ago)

        completed = student.completed_forms.order(created_at: :desc)
        expect(completed.first.created_at).to be > completed.last.created_at
      end

      it 'inclui apenas formulários publicados' do
        klass = create(:klass)
        form_template = create(:form_template)
        published_form = create(:form, klass: klass, form_template: form_template, status: :published)
        draft_form = create(:form, klass: klass, form_template: form_template, status: :draft)
        create(:class_member, user: student, klass: klass, role: 'dicente')

        pending = student.pending_forms
        expect(pending).to include(published_form)
        expect(pending).not_to include(draft_form)
      end

      it 'inclui formulários sem due_date' do
        klass = create(:klass)
        form_template = create(:form_template)
        form_no_date = create(:form, klass: klass, form_template: form_template, status: :published, due_date: nil)
        create(:class_member, user: student, klass: klass, role: 'dicente')

        pending = student.pending_forms
        expect(pending).to include(form_no_date)
      end

      it 'exclui formulários já respondidos' do
        klass = create(:klass)
        form_template = create(:form_template)
        form = create(:form, klass: klass, form_template: form_template, status: :published)
        create(:class_member, user: student, klass: klass, role: 'dicente')
        create(:form_response, form: form, user: student, submitted_at: Time.current)

        pending = student.pending_forms
        expect(pending).not_to include(form)
      end

      it 'inclui apenas formulários de turmas do usuário' do
        my_klass = create(:klass)
        other_klass = create(:klass)
        form_template = create(:form_template)
        my_form = create(:form, klass: my_klass, form_template: form_template, status: :published)
        other_form = create(:form, klass: other_klass, form_template: form_template, status: :published)
        create(:class_member, user: student, klass: my_klass, role: 'dicente')

        pending = student.pending_forms
        expect(pending).to include(my_form)
        expect(pending).not_to include(other_form)
      end

      it 'retorna completed_forms apenas respondidos' do
        klass = create(:klass)
        form_template = create(:form_template)
        form = create(:form, klass: klass, form_template: form_template, status: :published)
        create(:class_member, user: student, klass: klass, role: 'dicente')
        create(:form_response, form: form, user: student, submitted_at: Time.current)

        completed = student.completed_forms
        expect(completed).to include(form)
      end

      it 'exclui pending forms sem resposta' do
        klass = create(:klass)
        form_template = create(:form_template)
        form = create(:form, klass: klass, form_template: form_template, status: :published)
        create(:class_member, user: student, klass: klass, role: 'dicente')

        pending = student.pending_forms
        completed = student.completed_forms
        expect(pending).to include(form)
        expect(completed).not_to include(form)
      end
    end
  end
end
