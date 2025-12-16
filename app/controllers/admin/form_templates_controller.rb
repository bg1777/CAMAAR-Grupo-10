# app/controllers/admin/form_templates_controller.rb

module Admin
  ##
  # Controller para gerenciamento de templates de formulários.
  # Permite criar, editar, visualizar e deletar templates reutilizáveis.
  #
  class FormTemplatesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form_template, only: [:show, :edit, :update, :destroy]

    ##
    # Lista todos os templates de formulário do usuário atual.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @form_templates via query no banco (ordered by created_at DESC)
    # * Renderiza view admin/form_templates/index.html.erb
    #
    # ==== Exemplo
    #   GET /admin/form_templates # => lista templates mais recentes primeiro
    #
    def index
      @form_templates = current_user.form_templates.order(created_at: :desc)
    end

    ##
    # Exibe detalhes de um template específico.
    #
    # ==== Argumentos
    # * Nenhum (usa @form_template definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Renderiza view admin/form_templates/show.html.erb
    #
    # ==== Exemplo
    #   GET /admin/form_templates/1 # => exibe template e seus campos
    #
    def show
    end

    ##
    # Exibe formulário para criação de novo template.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Cria objeto FormTemplate em memória (@form_template)
    # * Adiciona 1 campo vazio via build para exibir no formulário
    # * Renderiza view admin/form_templates/new.html.erb
    #
    # ==== Exemplo
    #   GET /admin/form_templates/new # => formulário com 1 campo vazio
    #
    def new
      @form_template = FormTemplate.new
      @form_template.form_template_fields.build  # Apenas 1 campo vazio
    end

    ##
    # Cria um novo template de formulário com seus campos.
    #
    # ==== Argumentos
    # * Nenhum (usa form_template_params dos parâmetros do request)
    #
    # ==== Retorno
    # * Nenhum (redireciona ou renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Cria registro de FormTemplate no banco associado ao current_user
    # * Cria registros de FormTemplateField via accepts_nested_attributes
    # * Redireciona para show do template criado se salvou com sucesso
    # * Renderiza view new com status 422 se validações falharem
    #
    # ==== Exemplo
    #   POST /admin/form_templates
    #   # com dados válidos => redirect e "Template criado com sucesso!"
    #   # com erros => renderiza :new com mensagens de erro
    #
    def create
      @form_template = current_user.form_templates.build(form_template_params)

      if @form_template.save
        redirect_to admin_form_template_path(@form_template), notice: 'Template criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    ##
    # Exibe formulário de edição de template existente.
    #
    # ==== Argumentos
    # * Nenhum (usa @form_template definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Adiciona 1 campo vazio se o template não tiver nenhum campo
    # * Renderiza view admin/form_templates/edit.html.erb
    #
    # ==== Exemplo
    #   GET /admin/form_templates/1/edit # => formulário de edição
    #
    def edit
      @form_template.form_template_fields.build if @form_template.form_template_fields.empty?
    end

    ##
    # Atualiza um template de formulário existente.
    #
    # ==== Argumentos
    # * Nenhum (usa @form_template e form_template_params)
    #
    # ==== Retorno
    # * Nenhum (redireciona ou renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Atualiza registro de FormTemplate no banco
    # * Atualiza/cria/deleta FormTemplateFields via nested_attributes
    # * Redireciona para show do template se atualizar com sucesso
    # * Renderiza view edit com status 422 se validações falharem
    #
    # ==== Exemplo
    #   PATCH /admin/form_templates/1
    #   # com dados válidos => redirect e "Template atualizado com sucesso!"
    #
    def update
      if @form_template.update(form_template_params)
        redirect_to admin_form_template_path(@form_template), notice: 'Template atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    ##
    # Remove um template de formulário do sistema.
    #
    # ==== Argumentos
    # * Nenhum (usa @form_template definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Deleta registro de FormTemplate do banco
    # * Remove FormTemplateFields associados devido a dependent: :destroy
    # * Redireciona para lista de templates com mensagem de sucesso
    #
    # ==== Exemplo
    #   DELETE /admin/form_templates/1 # => deleta e redireciona
    #
    def destroy
      @form_template.destroy
      redirect_to admin_form_templates_url, notice: 'Template deletado com sucesso!'
    end

    private

    ##
    # Busca e define o template a partir do ID nos parâmetros da URL.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:id])
    #
    # ==== Retorno
    # * Nenhum (define @form_template)
    #
    # ==== Efeitos Colaterais
    # * Executa query no banco (FormTemplate.find)
    # * Levanta ActiveRecord::RecordNotFound se ID não existir
    #
    def set_form_template
      @form_template = FormTemplate.find(params[:id])
    end

    ##
    # Define os parâmetros permitidos para criação/atualização de template.
    # Inclui nested attributes para campos do formulário.
    #
    # ==== Argumentos
    # * Nenhum (usa params do request)
    #
    # ==== Retorno
    # * +ActionController::Parameters+ - parâmetros filtrados e permitidos
    #
    # ==== Efeitos Colaterais
    # * Nenhum (apenas filtragem de parâmetros)
    #
    def form_template_params
      params.require(:form_template).permit(
        :name, :description,
        form_template_fields_attributes: [:id, :field_type, :label, :required, :options, :position, :_destroy]
      )
    end

    ##
    # Verifica se o usuário atual possui perfil de administrador.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user do Devise)
    #
    # ==== Retorno
    # * Nenhum (void ou redireciona)
    #
    # ==== Efeitos Colaterais
    # * Redireciona para root_path com alerta se não for admin
    #
    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
