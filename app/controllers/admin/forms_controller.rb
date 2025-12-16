# app/controllers/admin/forms_controller.rb

module Admin
  ##
  # Controller para gerenciamento de formulários pelos administradores.
  # Permite criar, editar, publicar, fechar e visualizar respostas de formulários.
  #
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy, :publish, :close, :view_response]
    before_action :set_form_response, only: [:view_response]

    ##
    # Lista todos os formulários do sistema.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @forms com todos os formulários ordenados por data de criação (DESC)
    # * Renderiza view admin/forms/index.html.erb
    #
    # ==== Exemplo
    #   GET /admin/forms # => lista formulários mais recentes primeiro
    #
    def index
      @forms = Form.all.order(created_at: :desc)
    end

    ##
    # Exibe detalhes de um formulário com estatísticas de respostas.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Calcula @pending_count (respostas pendentes) via query COUNT
    # * Calcula @completed_count (respostas completadas) via query COUNT
    # * Renderiza view admin/forms/show.html.erb
    #
    # ==== Exemplo
    #   GET /admin/forms/1 # => exibe formulário com estatísticas
    #
    def show
      @pending_count = @form.pending_responses.count
      @completed_count = @form.completed_responses.count
    end

    ##
    # Exibe formulário para criação de novo formulário.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Cria objeto Form em memória (@form)
    # * Carrega @form_templates e @klasses para os selects do formulário
    # * Renderiza view admin/forms/new.html.erb
    #
    # ==== Exemplo
    #   GET /admin/forms/new # => formulário de criação
    #
    def new
      @form = Form.new
      load_form_dependencies
    end

    ##
    # Cria um novo formulário associado a template e turma.
    #
    # ==== Argumentos
    # * Nenhum (usa form_params dos parâmetros do request)
    #
    # ==== Retorno
    # * Nenhum (redireciona ou renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Cria registro de Form no banco com status :draft
    # * Associa FormTemplate e Klass ao formulário
    # * Redireciona para show do formulário criado se salvou com sucesso
    # * Renderiza view new com status 422 se validações falharem
    #
    # ==== Exemplo
    #   POST /admin/forms
    #   # com dados válidos => redirect e "Formulário criado com sucesso!"
    #
    def create
      @form = build_form_from_params

      if @form.save
        redirect_to admin_form_path(@form), notice: 'Formulário criado com sucesso!'
      else
        load_form_dependencies
        render :new, status: :unprocessable_entity
      end
    end

    ##
    # Exibe formulário de edição de formulário existente.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @form_templates e @klasses para os selects
    # * Renderiza view admin/forms/edit.html.erb
    #
    # ==== Exemplo
    #   GET /admin/forms/1/edit # => formulário de edição
    #
    def edit
      load_form_dependencies
    end

    ##
    # Atualiza um formulário existente.
    #
    # ==== Argumentos
    # * Nenhum (usa @form e form_params)
    #
    # ==== Retorno
    # * Nenhum (redireciona ou renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Atualiza registro de Form no banco
    # * Redireciona para show do formulário se atualizar com sucesso
    # * Renderiza view edit com status 422 se validações falharem
    #
    # ==== Exemplo
    #   PATCH /admin/forms/1
    #   # com dados válidos => redirect e "Formulário atualizado com sucesso!"
    #
    def update
      if @form.update(form_params)
        redirect_to admin_form_path(@form), notice: 'Formulário atualizado com sucesso!'
      else
        load_form_dependencies
        render :edit, status: :unprocessable_entity
      end
    end

    ##
    # Remove um formulário do sistema.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Deleta registro de Form do banco
    # * Remove FormResponses e FormAnswers associados devido a dependent: :destroy
    # * Redireciona para lista de formulários com mensagem de sucesso
    #
    # ==== Exemplo
    #   DELETE /admin/forms/1 # => deleta e redireciona
    #
    def destroy
      @form.destroy
      redirect_to admin_forms_url, notice: 'Formulário deletado com sucesso!'
    end

    ##
    # Publica um formulário, tornando-o disponível para os alunos.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Atualiza status do formulário para :published no banco
    # * Torna o formulário visível e respondível pelos alunos da turma
    # * Redireciona para show do formulário com mensagem de sucesso ou erro
    #
    # ==== Exemplo
    #   PATCH /admin/forms/1/publish # => muda status para published
    #
    def publish
      if @form.update(status: :published)
        redirect_to admin_form_path(@form), notice: 'Formulário publicado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao publicar formulário'
      end
    end

    ##
    # Fecha um formulário, impedindo novas respostas.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Atualiza status do formulário para :closed no banco
    # * Impede que alunos enviem novas respostas
    # * Redireciona para show do formulário com mensagem de sucesso ou erro
    #
    # ==== Exemplo
    #   PATCH /admin/forms/1/close # => muda status para closed
    #
    def close
      if @form.update(status: :closed)
        redirect_to admin_form_path(@form), notice: 'Formulário fechado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao fechar formulário'
      end
    end

    ##
    # Visualiza a resposta de um aluno específico ao formulário.
    #
    # ==== Argumentos
    # * Nenhum (usa @form e @form_response definidos pelos before_actions)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Renderiza view admin/forms/view_response.html.erb
    # * Exibe todas as respostas do aluno ao formulário
    #
    # ==== Exemplo
    #   GET /admin/forms/1/responses/5 # => exibe respostas do aluno
    #
    def view_response
      # @form_response já é setado pelo before_action
    end

    private

    ##
    # Constrói objeto Form a partir dos parâmetros do request.
    # Define status inicial como :draft.
    #
    # ==== Argumentos
    # * Nenhum (usa form_params)
    #
    # ==== Retorno
    # * +Form+ - objeto Form não persistido (apenas em memória)
    #
    # ==== Efeitos Colaterais
    # * Executa queries para buscar FormTemplate e Klass
    # * Cria objeto Form em memória
    #
    def build_form_from_params
      Form.new(
        form_template: FormTemplate.find(form_params[:form_template_id]),
        klass: Klass.find(form_params[:klass_id]),
        title: form_params[:title],
        description: form_params[:description],
        due_date: form_params[:due_date],
        status: :draft
      )
    end

    ##
    # Carrega dados necessários para os selects do formulário.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (define variáveis de instância)
    #
    # ==== Efeitos Colaterais
    # * Executa queries no banco para carregar @form_templates e @klasses
    #
    def load_form_dependencies
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    ##
    # Busca e define o formulário a partir do ID nos parâmetros da URL.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:id])
    #
    # ==== Retorno
    # * Nenhum (define @form)
    #
    # ==== Efeitos Colaterais
    # * Executa query no banco (Form.find)
    # * Levanta ActiveRecord::RecordNotFound se ID não existir
    #
    def set_form
      @form = Form.find(params[:id])
    end

    ##
    # Busca e define a resposta a partir do ID nos parâmetros da URL.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:response_id])
    #
    # ==== Retorno
    # * Nenhum (define @form_response)
    #
    # ==== Efeitos Colaterais
    # * Executa query no banco (FormResponse.find)
    # * Levanta ActiveRecord::RecordNotFound se ID não existir
    #
    def set_form_response
      @form_response = FormResponse.find(params[:response_id])
    end

    ##
    # Define os parâmetros permitidos para criação/atualização de formulário.
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
    def form_params
      params.require(:form).permit(:form_template_id, :klass_id, :title, :description, :due_date, :status)
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
