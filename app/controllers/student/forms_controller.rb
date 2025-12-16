# app/controllers/student/forms_controller.rb - CORRIGIDO

module Student
  ##
  # Controller para gerenciamento de formulários pelos alunos.
  # Permite visualizar, responder e submeter formulários das suas turmas.
  #
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_student
    before_action :set_form, only: [:show, :answer, :submit_answer]
    before_action :check_form_accessible, only: [:show, :answer, :submit_answer]

    ##
    # Lista formulários pendentes e completados do aluno atual.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @pending_forms ordenados por due_date ASC via query
    # * Carrega @completed_forms ordenados por created_at DESC via query
    # * Renderiza view student/forms/index.html.erb
    #
    # ==== Exemplo
    #   GET /student/forms # => lista formulários do aluno
    #
    def index
      @pending_forms = current_user.pending_forms.order(due_date: :asc)
      @completed_forms = current_user.completed_forms.order(created_at: :desc)
    end

    ##
    # Exibe detalhes de um formulário para o aluno.
    #
    # ==== Argumentos
    # * Nenhum (usa @form definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Busca ou cria FormResponse do aluno para este formulário
    # * Define @form_response (existente ou novo objeto em memória)
    # * Renderiza view student/forms/show.html.erb
    #
    # ==== Exemplo
    #   GET /student/forms/1 # => exibe formulário
    #
    def show
      @form_response = @form.form_responses.find_by(user: current_user)
      @form_response ||= FormResponse.new(form: @form, user: current_user)
    end

    ##
    # Prepara o formulário para ser respondido pelo aluno.
    # Cria FormResponse e FormAnswers vazios se ainda não existirem.
    #
    # ==== Argumentos
    # * Nenhum (usa @form e current_user)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Cria FormResponse no banco se não existir (sem validação)
    # * Cria FormAnswers vazios para todos os campos do template
    # * Executa @form_response.reload para buscar dados atualizados
    # * Renderiza view student/forms/answer.html.erb
    #
    # ==== Exemplo
    #   GET /student/forms/1/answer # => formulário pronto para responder
    #
    def answer
      @form_response = @form.form_responses.find_by(user: current_user)

      if @form_response.nil?
        @form_response = FormResponse.new(form: @form, user: current_user)
        @form_response.save(validate: false)
        @form_response.build_answers_for_fields
        @form_response.save(validate: false)
      end

      @form_response.reload

      # Se não há respostas, criar agora
      if @form_response.form_answers.empty?
        @form_response.build_answers_for_fields
        @form_response.save(validate: false)
      end
    end

    ##
    # Submete as respostas do aluno ao formulário.
    # Atualiza FormAnswers e marca FormResponse como submetido.
    #
    # ==== Argumentos
    # * Nenhum (usa @form e params do formulário)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Atualiza registros de FormAnswer no banco com as respostas do aluno
    # * Marca FormResponse como submetido (atualiza submitted_at)
    # * Redireciona para root_path com mensagem de sucesso se salvou
    # * Redireciona para answer com erro se falhar
    #
    # ==== Exemplo
    #   POST /student/forms/1/submit_answer
    #   # com respostas válidas => redirect e "Formulário respondido com sucesso!"
    #
    def submit_answer
      @form_response = @form.form_responses.find_by(user: current_user)

      if @form_response.nil?
        redirect_to student_form_path(@form), alert: 'Resposta não encontrada'
        return
      end

      if update_answers && @form_response.submit!
        redirect_to root_path, notice: 'Formulário respondido com sucesso!'
      else
        redirect_to answer_student_form_path(@form), alert: 'Erro ao salvar respostas'
      end
    end

    private

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
    # Verifica se o usuário é aluno (não administrador).
    # Redireciona administradores para o dashboard.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user)
    #
    # ==== Retorno
    # * Nenhum (void ou redireciona)
    #
    # ==== Efeitos Colaterais
    # * Redireciona para admin_root_path se usuário for admin
    #
    def check_student
      redirect_to admin_root_path if current_user.admin?
    end

    ##
    # Verifica se o formulário está acessível para o aluno atual.
    # Checa se aluno pertence à turma e se formulário está publicado.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user e @form)
    #
    # ==== Retorno
    # * Nenhum (void ou redireciona)
    #
    # ==== Efeitos Colaterais
    # * Executa query para verificar se aluno está na turma do formulário
    # * Redireciona para root_path com alerta se acesso negado
    #
    def check_form_accessible
      unless current_user.klasses.include?(@form.klass) && @form.published?
        redirect_to root_path, alert: 'Acesso negado a este formulário'
      end
    end

    ##
    # Atualiza as respostas dos campos do formulário com os dados do aluno.
    #
    # ==== Argumentos
    # * Nenhum (usa params e @form_response)
    #
    # ==== Retorno
    # * +Boolean+ - true se atualizou com sucesso, false caso contrário
    #
    # ==== Efeitos Colaterais
    # * Atualiza registros de FormAnswer no banco via nested_attributes
    # * Executa validações dos FormAnswers
    #
    def update_answers
      form_answers_params = params.require(:form_response).permit(form_answers_attributes: [:id, :answer])
      @form_response.update(form_answers_params)
    end
  end
end
