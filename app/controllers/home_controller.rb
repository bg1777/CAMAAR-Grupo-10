# app/controllers/home_controller.rb

##
# Controller responsável pela página inicial do sistema.
# Redireciona administradores para o dashboard e exibe formulários para alunos.
#
class HomeController < ApplicationController
  before_action :authenticate_user!

  ##
  # Exibe a página inicial conforme o perfil do usuário.
  # Administradores são redirecionados para o dashboard admin.
  # Alunos visualizam seus formulários pendentes e completados.
  #
  # ==== Argumentos
  # * Nenhum (usa current_user do Devise)
  #
  # ==== Retorno
  # * Nenhum (renderiza view ou redireciona)
  #
  # ==== Efeitos Colaterais
  # * Redireciona para admin_root_path se usuário for admin
  # * Carrega @pending_forms e @completed_forms via queries no banco
  # * Renderiza view home/index.html.erb para usuários dicentes
  #
  # ==== Exemplo
  #   # Admin visitando a home
  #   GET / # => redirect_to admin_root_path
  #
  #   # Aluno visitando a home
  #   GET / # => renderiza home/index com formulários
  #
  def index
    if current_user.admin?
      redirect_to admin_root_path
    else
      @pending_forms = current_user.pending_forms.order(due_date: :asc)
      @completed_forms = current_user.completed_forms.order(created_at: :desc)
    end
  end
end
