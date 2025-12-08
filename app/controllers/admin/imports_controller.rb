# app/controllers/admin/imports_controller.rb

module Admin
  class ImportsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def index
      @total_klasses = Klass.count
      @total_users = User.where(role: :user).count
    end

    def import_klasses
      if params[:file].blank?
        redirect_to admin_imports_path, alert: 'Por favor, selecione um arquivo'
        return
      end

      file = params[:file]
      
      # Validar tipo de arquivo
      unless file.content_type == 'application/json' || file.original_filename.end_with?('.json')
        redirect_to admin_imports_path, alert: 'Por favor, envie um arquivo JSON válido'
        return
      end

      # Executar importação
      service = ImportService.new(file.path)
      result = service.import_klasses

      if result[:success]
        message = "✅ #{result[:imported]} turma(s) importada(s) com sucesso!"
        
        if result[:errors].present?
          message += "\n\n⚠️ Aviso: #{result[:errors].count} erro(s) durante importação:"
          result[:errors].each { |error| message += "\n• #{error}" }
          redirect_to admin_imports_path, alert: message
        else
          redirect_to admin_imports_path, notice: message
        end
      else
        redirect_to admin_imports_path, alert: "❌ Erro na importação: #{result[:error]}"
      end
    end

    private

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end