# app/controllers/admin/form_templates_controller.rb

module Admin
  class FormTemplatesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_form_template, only: [:show, :edit, :update, :destroy]

    def index
      @form_templates = current_user.form_templates.order(created_at: :desc)
    end

    def show
    end

    def new
      @form_template = FormTemplate.new
      @form_template.form_template_fields.build  # Apenas 1 campo vazio
    end

    def create
      @form_template = current_user.form_templates.build(form_template_params)

      if @form_template.save
        redirect_to admin_form_template_path(@form_template), notice: 'Template criado com sucesso!'
      else
        # Debug: mostra os erros
        puts "❌ Erros ao salvar template:"
        puts @form_template.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @form_template.form_template_fields.build if @form_template.form_template_fields.empty?
    end

    def update
      if @form_template.update(form_template_params)
        redirect_to admin_form_template_path(@form_template), notice: 'Template atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @form_template.destroy
      redirect_to admin_form_templates_url, notice: 'Template deletado com sucesso!'
    end

    private

    def set_form_template
      @form_template = FormTemplate.find(params[:id])
    end

    def form_template_params
      params.require(:form_template).permit(
        :name, :description,
        form_template_fields_attributes: [:id, :field_type, :label, :required, :options, :position, :_destroy]
      )
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
