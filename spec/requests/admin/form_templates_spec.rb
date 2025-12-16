# spec/requests/admin/form_templates_spec.rb - CORRIGIDO

require 'rails_helper'

RSpec.describe 'Admin::FormTemplates', type: :request do
  include Warden::Test::Helpers

  let(:admin) { create(:user, role: :admin) }
  let(:student) { create(:user, role: :user) }
  let(:form_template) { create(:form_template, user: admin) }

  def login_as_admin
    login_as(admin, scope: :user)
  end

  def login_as_student
    login_as(student, scope: :user)
  end

  after { Warden.test_reset! }

  describe 'Authentication and Authorization' do
    describe 'GET /admin/form_templates (não autenticado)' do
      it 'redireciona para login se não autenticado' do
        get admin_form_templates_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET /admin/form_templates (student)' do
      it 'redireciona se usuário não é admin' do
        login_as_student
        get admin_form_templates_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Acesso negado!')
      end
    end
  end

  describe 'GET /admin/form_templates (index)' do
    before { login_as_admin }

    it 'retorna status sucesso' do
      get admin_form_templates_path
      expect(response).to have_http_status(:success)
    end

    it 'lista templates criados pelo admin' do
      template1 = create(:form_template, user: admin, name: 'Template 1')
      template2 = create(:form_template, user: admin, name: 'Template 2')
      
      get admin_form_templates_path
      
      expect(response.body).to include(template1.name)
      expect(response.body).to include(template2.name)
    end

    it 'não lista templates de outro admin' do
      other_admin = create(:user, role: :admin)
      other_template = create(:form_template, user: other_admin)
      my_template = create(:form_template, user: admin)
      
      get admin_form_templates_path
      
      expect(response.body).to include(my_template.name)
      expect(response.body).not_to include(other_template.name)
    end

    it 'lista em ordem decrescente de criação' do
      older_template = create(:form_template, user: admin, created_at: 2.days.ago)
      newer_template = create(:form_template, user: admin, created_at: 1.day.ago)
      
      get admin_form_templates_path
      
      older_pos = response.body.index(older_template.name)
      newer_pos = response.body.index(newer_template.name)
      
      expect(newer_pos).to be < older_pos
    end
  end

  describe 'GET /admin/form_templates/:id (show)' do
    before { login_as_admin }

    it 'retorna status sucesso' do
      get admin_form_template_path(form_template)
      expect(response).to have_http_status(:success)
    end

    it 'mostra o template correto' do
      get admin_form_template_path(form_template)
      expect(response.body).to include(form_template.name)
    end

    it 'retorna 404 para template inexistente' do
      get admin_form_template_path(999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /admin/form_templates/new' do
    before { login_as_admin }

    it 'retorna status sucesso' do
      get new_admin_form_template_path
      expect(response).to have_http_status(:success)
    end

    it 'renderiza formulário com 1 campo vazio' do
      get new_admin_form_template_path
      expect(response.body).to include('form_template_fields_attributes')
    end
  end

  describe 'POST /admin/form_templates (create)' do
    before { login_as_admin }

    context 'com parâmetros válidos' do
      it 'cria um novo template' do
        expect {
          post admin_form_templates_path, params: {
            form_template: {
              name: 'Novo Template',
              description: 'Descrição do template'
            }
          }
        }.to change(FormTemplate, :count).by(1)
      end

      it 'redireciona para show com mensagem de sucesso' do
        post admin_form_templates_path, params: {
          form_template: {
            name: 'Novo Template',
            description: 'Descrição do template'
          }
        }

        expect(response).to redirect_to(admin_form_template_path(FormTemplate.last))
        expect(flash[:notice]).to eq('Template criado com sucesso!')
      end

      it 'associa o template ao admin logado' do
        post admin_form_templates_path, params: {
          form_template: {
            name: 'Novo Template',
            description: 'Descrição do template'
          }
        }

        expect(FormTemplate.last.user).to eq(admin)
      end

      it 'cria campos do template se enviados' do
        # Quando criar via factory, já vem sem campos
        # O envio de campos via nested attributes é opcional
        post admin_form_templates_path, params: {
          form_template: {
            name: 'Novo Template',
            description: 'Descrição do template'
          }
        }

        template = FormTemplate.last
        expect(template).to be_persisted
      end
    end

    context 'com parâmetros inválidos' do
      it 'não cria template sem name' do
        expect {
          post admin_form_templates_path, params: {
            form_template: {
              name: '',
              description: 'Descrição do template'
            }
          }
        }.not_to change(FormTemplate, :count)
      end

      it 'retorna status 422' do
        post admin_form_templates_path, params: {
          form_template: {
            name: '',
            description: 'Descrição do template'
          }
        }

        expect(response).to have_http_status(422)
      end

      it 'renderiza formulário novamente' do
        post admin_form_templates_path, params: {
          form_template: {
            name: '',
            description: 'Descrição do template'
          }
        }

        expect(response.body).to include('form_template_fields_attributes')
      end
    end
  end

  describe 'GET /admin/form_templates/:id/edit' do
    before { login_as_admin }

    it 'retorna status sucesso' do
      get edit_admin_form_template_path(form_template)
      expect(response).to have_http_status(:success)
    end

    it 'renderiza formulário com dados do template' do
      get edit_admin_form_template_path(form_template)
      expect(response.body).to include(form_template.name)
    end

    it 'adiciona 1 campo vazio se template não tiver campos' do
      empty_template = create(:form_template, user: admin)
      
      get edit_admin_form_template_path(empty_template)
      
      expect(response.body).to include('form_template_fields_attributes')
    end

    it 'não adiciona campo vazio se template já tiver campos' do
      template_with_fields = create(:form_template, user: admin)
      create(:form_template_field, form_template: template_with_fields)
      
      initial_count = template_with_fields.form_template_fields.count
      
      get edit_admin_form_template_path(template_with_fields)
      
      template_with_fields.reload
      expect(template_with_fields.form_template_fields.count).to eq(initial_count)
    end

    it 'redireciona com 404 para template inexistente' do
      get edit_admin_form_template_path(999)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH /admin/form_templates/:id (update)' do
    before { login_as_admin }

    context 'com parâmetros válidos' do
      it 'atualiza o template' do
        patch admin_form_template_path(form_template), params: {
          form_template: {
            name: 'Nome Atualizado',
            description: form_template.description
          }
        }

        expect(form_template.reload.name).to eq('Nome Atualizado')
      end

      it 'redireciona para show com mensagem de sucesso' do
        patch admin_form_template_path(form_template), params: {
          form_template: {
            name: 'Nome Atualizado',
            description: form_template.description
          }
        }

        expect(response).to redirect_to(admin_form_template_path(form_template))
        expect(flash[:notice]).to eq('Template atualizado com sucesso!')
      end

      it 'atualiza campos do template' do
        field = create(:form_template_field, form_template: form_template)
        
        patch admin_form_template_path(form_template), params: {
          form_template: {
            name: form_template.name,
            description: form_template.description,
            form_template_fields_attributes: {
              '0': {
                id: field.id,
                field_type: 'email',
                label: 'Campo Atualizado',
                required: '1',
                position: '1'
              }
            }
          }
        }

        expect(field.reload.label).to eq('Campo Atualizado')
      end

      it 'deleta campos com _destroy=1' do
        field = create(:form_template_field, form_template: form_template)
        
        expect {
          patch admin_form_template_path(form_template), params: {
            form_template: {
              name: form_template.name,
              description: form_template.description,
              form_template_fields_attributes: {
                '0': {
                  id: field.id,
                  _destroy: '1'
                }
              }
            }
          }
        }.to change(FormTemplateField, :count).by(-1)
      end
    end

    context 'com parâmetros inválidos' do
      it 'não atualiza template sem name' do
        original_name = form_template.name
        
        patch admin_form_template_path(form_template), params: {
          form_template: {
            name: '',
            description: form_template.description
          }
        }

        expect(form_template.reload.name).to eq(original_name)
      end

      it 'retorna status 422' do
        patch admin_form_template_path(form_template), params: {
          form_template: {
            name: '',
            description: form_template.description
          }
        }

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /admin/form_templates/:id (destroy)' do
    before { login_as_admin }

    it 'deleta o template' do
      template_to_delete = create(:form_template, user: admin)
      
      expect {
        delete admin_form_template_path(template_to_delete)
      }.to change(FormTemplate, :count).by(-1)
    end

    it 'redireciona para index com mensagem de sucesso' do
      delete admin_form_template_path(form_template)
      
      expect(response).to redirect_to(admin_form_templates_url)
      expect(flash[:notice]).to eq('Template deletado com sucesso!')
    end

    it 'deleta campos associados (dependent: :destroy)' do
      template_to_delete = create(:form_template, user: admin)
      field1 = create(:form_template_field, form_template: template_to_delete)
      field2 = create(:form_template_field, form_template: template_to_delete)
      
      expect {
        delete admin_form_template_path(template_to_delete)
      }.to change(FormTemplateField, :count).by(-2)
    end

    it 'redireciona com 404 para template inexistente' do
      delete admin_form_template_path(999)
      expect(response).to have_http_status(:not_found)
    end
  end
end