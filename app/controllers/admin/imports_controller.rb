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
      return redirect_with_error('Por favor, selecione um arquivo') if params[:file].blank?
      return redirect_with_error('Por favor, envie um arquivo JSON válido') unless valid_json_file?

      result = ImportService.new(params[:file].path).import_klasses
      handle_import_result(result)
    end

    private

    def valid_json_file?
      file = params[:file]
      file.content_type == 'application/json' || file.original_filename.end_with?('.json')
    end

    def redirect_with_error(message)
      redirect_to admin_imports_path, alert: message
    end

    def handle_import_result(result)
      if result[:success]
        handle_success(result)
      else
        redirect_with_error("❌ Erro na importação: #{result[:error]}")
      end
    end

    def handle_success(result)
      message = "✅ #{result[:imported]} turma(s) importada(s) com sucesso!"
      
      if result[:errors].present?
        redirect_to admin_imports_path, alert: build_error_message(message, result[:errors])
      else
        redirect_to admin_imports_path, notice: message
      end
    end

    def build_error_message(base_message, errors)
      message = "#{base_message}\n\n⚠️ Aviso: #{errors.count} erro(s) durante importação:"
      errors.each { |error| message += "\n• #{error}" }
      message
    end

    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
