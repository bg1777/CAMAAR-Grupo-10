# app/controllers/admin/imports_controller.rb

module Admin
  ##
  # Controller responsável pela importação de dados do SIGAA.
  # Permite importar turmas e alunos através de arquivos JSON.
  #
  class ImportsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    ##
    # Exibe a página de importação com estatísticas atuais.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Executa queries COUNT no banco para carregar @total_klasses e @total_users
    # * Renderiza view admin/imports/index.html.erb
    #
    # ==== Exemplo
    #   GET /admin/imports # => renderiza página com estatísticas
    #
    def index
      @total_klasses = Klass.count
      @total_users = User.where(role: :user).count
    end

    ##
    # Processa o arquivo JSON de importação de turmas.
    # Valida o arquivo e delega o processamento ao ImportService.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:file] do formulário)
    #
    # ==== Retorno
    # * Nenhum (redireciona com mensagem de sucesso ou erro)
    #
    # ==== Efeitos Colaterais
    # * Valida presença e tipo do arquivo enviado
    # * Cria instância de ImportService e executa importação
    # * Cria/atualiza registros de Klass, User e ClassMember no banco
    # * Redireciona para admin_imports_path com mensagem de resultado
    #
    # ==== Exemplo
    #   POST /admin/imports/import_klasses
    #   # com arquivo válido => "✅ 5 turma(s) importada(s) com sucesso!"
    #   # sem arquivo => "Por favor, selecione um arquivo"
    #
    def import_klasses
      return redirect_with_error('Por favor, selecione um arquivo') if params[:file].blank?
      return redirect_with_error('Por favor, envie um arquivo JSON válido') unless valid_json_file?

      result = ImportService.new(params[:file].path).import_klasses
      handle_import_result(result)
    end

    private

    ##
    # Verifica se o arquivo enviado é um JSON válido.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:file])
    #
    # ==== Retorno
    # * +Boolean+ - true se o content_type for 'application/json' ou extensão for '.json'
    #
    # ==== Efeitos Colaterais
    # * Nenhum (apenas validação)
    #
    def valid_json_file?
      file = params[:file]
      file.content_type == 'application/json' || file.original_filename.end_with?('.json')
    end

    ##
    # Redireciona para página de importação com mensagem de erro.
    #
    # ==== Argumentos
    # * +message+ - (String) mensagem de erro a ser exibida
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Redireciona para admin_imports_path com alert
    #
    def redirect_with_error(message)
      redirect_to admin_imports_path, alert: message
    end

    ##
    # Processa o resultado da importação e redireciona com mensagem apropriada.
    #
    # ==== Argumentos
    # * +result+ - (Hash) resultado retornado pelo ImportService contendo:
    #   * +:success+ (Boolean)
    #   * +:imported+ (Integer)
    #   * +:errors+ (Array<String>)
    #   * +:error+ (String) - apenas se success: false
    #
    # ==== Retorno
    # * Nenhum (redireciona via handle_success ou redirect_with_error)
    #
    # ==== Efeitos Colaterais
    # * Chama handle_success se resultado for positivo
    # * Chama redirect_with_error se houver falha crítica
    #
    def handle_import_result(result)
      if result[:success]
        handle_success(result)
      else
        redirect_with_error("❌ Erro na importação: #{result[:error]}")
      end
    end

    ##
    # Trata importações bem-sucedidas, incluindo avisos de erros parciais.
    #
    # ==== Argumentos
    # * +result+ - (Hash) resultado da importação com :imported e :errors
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Redireciona com notice se não houver erros parciais
    # * Redireciona com alert contendo lista de erros se houver erros parciais
    #
    def handle_success(result)
      message = "✅ #{result[:imported]} turma(s) importada(s) com sucesso!"

      if result[:errors].present?
        redirect_to admin_imports_path, alert: build_error_message(message, result[:errors])
      else
        redirect_to admin_imports_path, notice: message
      end
    end

    ##
    # Constrói mensagem formatada com erros parciais da importação.
    #
    # ==== Argumentos
    # * +base_message+ - (String) mensagem base de sucesso
    # * +errors+ - (Array<String>) lista de erros ocorridos durante importação
    #
    # ==== Retorno
    # * +String+ - mensagem formatada com lista de erros
    #
    # ==== Efeitos Colaterais
    # * Nenhum (apenas concatenação de strings)
    #
    # ==== Exemplo
    #   build_error_message("5 turmas importadas", ["Erro ao importar João"])
    #   # => "5 turmas importadas\n\n⚠️ Aviso: 1 erro(s) durante importação:\n• Erro ao importar João"
    #
    def build_error_message(base_message, errors)
      message = "#{base_message}\n\n⚠️ Aviso: #{errors.count} erro(s) durante importação:"
      errors.each { |error| message += "\n• #{error}" }
      message
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
