# app/controllers/admin/forms_controller.rb

module Admin
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy, :publish, :close, :view_response]
    before_action :set_form_response, only: [:view_response]

    def index
      @forms = Form.all.order(created_at: :desc)
    end

    def show
      @pending_count = @form.pending_responses.count
      @completed_count = @form.completed_responses.count
    end

    def new
      @form = Form.new
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    def create
      template = FormTemplate.find(form_params[:form_template_id])
      klass = Klass.find(form_params[:klass_id])
      
      @form = Form.new(
        form_template: template,
        klass: klass,
        title: form_params[:title],
        description: form_params[:description],
        due_date: form_params[:due_date],
        status: :draft
      )

      if @form.save
        redirect_to admin_form_path(@form), notice: 'Formulário criado com sucesso!'
      else
        @form_templates = FormTemplate.all
        @klasses = Klass.all
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @form_templates = FormTemplate.all
      @klasses = Klass.all
    end

    def update
      if @form.update(form_params)
        redirect_to admin_form_path(@form), notice: 'Formulário atualizado com sucesso!'
      else
        @form_templates = FormTemplate.all
        @klasses = Klass.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @form.destroy
      redirect_to admin_forms_url, notice: 'Formulário deletado com sucesso!'
    end

    def publish
      if @form.update(status: :published)
        redirect_to admin_form_path(@form), notice: 'Formulário publicado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao publicar formulário'
      end
    end

    def close
      if @form.update(status: :closed)
        redirect_to admin_form_path(@form), notice: 'Formulário fechado com sucesso!'
      else
        redirect_to admin_form_path(@form), alert: 'Erro ao fechar formulário'
      end
    end

    def view_response
      # @form_response já é setado pelo before_action
    end

    private

    def set_form
      @form = Form.find(params[:id])
    end

    def set_form_response
      @form_response = FormResponse.find(params[:response_id])
    end

    def form_params
      params.require(:form).permit(:form_template_id, :klass_id, :title, :description, :due_date, :status)
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
