# app/controllers/admin/dashboard_controller.rb

module Admin
  ##
  # Controller do dashboard administrativo.
  # Exibe estatísticas e resumo geral do sistema para administradores.
  #
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    ##
    # Exibe o dashboard com estatísticas de usuários do sistema.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @users com todos os usuários do banco (User.all)
    # * Calcula @total_users e @admin_count via queries COUNT no banco
    # * Renderiza view admin/dashboard/index.html.erb
    #
    # ==== Exemplo
    #   GET /admin # => renderiza dashboard com estatísticas
    #
    def index
      @users = User.all
      @total_users = User.count
      @admin_count = User.where(role: :admin).count
    end

    private

    ##
    # Verifica se o usuário atual possui perfil de administrador.
    # Redireciona para página inicial se não for admin.
    #
    # ==== Argumentos
    # * Nenhum (usa current_user do Devise)
    #
    # ==== Retorno
    # * Nenhum (void ou redireciona)
    #
    # ==== Efeitos Colaterais
    # * Redireciona para root_path com mensagem de alerta se não for admin
    # * Interrompe a execução da action se redirecionar
    #
    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
