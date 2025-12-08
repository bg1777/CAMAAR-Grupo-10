# app/controllers/admin/forms_controller.rb

module Admin
  class FormsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form, only: [:show, :edit, :update, :destroy, :publish, :close]

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
      
      @form = template.create_form_instance(
        klass,
        form_params[:title],
        form_params[:description],
        form_params[:due_date]
      )

      if @form.save
        redirect_to admin_form_path(@form), notice: 'Formulário criado com sucesso!'
      else
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

    private

    def set_form
      @form = Form.find(params[:id])
    end

    def form_params
      params.require(:form).permit(:form_template_id, :klass_id, :title, :description, :due_date, :status)
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end