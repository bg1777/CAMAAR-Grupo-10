# app/controllers/student/forms_controller.rb - CORRIGIDO

module Student
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_student
    before_action :set_form, only: [:show, :answer, :submit_answer]
    before_action :check_form_accessible, only: [:show, :answer, :submit_answer]

    def index
      @pending_forms = current_user.pending_forms.order(due_date: :asc)
      @completed_forms = current_user.completed_forms.order(created_at: :desc)
    end

    def show
      @form_response = @form.form_responses.find_by(user: current_user)
      @form_response ||= FormResponse.new(form: @form, user: current_user)
    end

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

    def set_form
      @form = Form.find(params[:id])
    end

    def check_student
      redirect_to admin_root_path if current_user.admin?
    end

    def check_form_accessible
      unless current_user.klasses.include?(@form.klass) && @form.published?
        redirect_to root_path, alert: 'Acesso negado a este formulário'
      end
    end

    def update_answers
      form_answers_params = params.require(:form_response).permit(form_answers_attributes: [:id, :answer])
      @form_response.update(form_answers_params)
    end
  end
end