# app/controllers/admin/users_controller.rb

module Admin
  ##
  # Controller para gerenciamento de usuários pelos administradores.
  # Permite listar, visualizar, editar e deletar usuários do sistema.
  #
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    ##
    # Lista todos os usuários cadastrados no sistema.
    #
    # ==== Argumentos
    # * Nenhum
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Carrega @users com todos os registros de User via query no banco
    # * Renderiza view admin/users/index.html.erb
    #
    # ==== Exemplo
    #   GET /admin/users # => renderiza lista de usuários
    #
    def index
      @users = User.all
    end

    ##
    # Exibe detalhes de um usuário específico.
    #
    # ==== Argumentos
    # * Nenhum (usa @user definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Renderiza view admin/users/show.html.erb com dados de @user
    #
    # ==== Exemplo
    #   GET /admin/users/1 # => renderiza detalhes do usuário ID 1
    #
    def show
    end

    ##
    # Exibe formulário de edição de usuário.
    #
    # ==== Argumentos
    # * Nenhum (usa @user definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Renderiza view admin/users/edit.html.erb com formulário
    #
    # ==== Exemplo
    #   GET /admin/users/1/edit # => renderiza formulário de edição
    #
    def edit
    end

    ##
    # Atualiza os dados de um usuário.
    #
    # ==== Argumentos
    # * Nenhum (usa @user e params do formulário)
    #
    # ==== Retorno
    # * Nenhum (redireciona ou renderiza view)
    #
    # ==== Efeitos Colaterais
    # * Atualiza registro de User no banco de dados se validações passarem
    # * Redireciona para admin_users_path com mensagem de sucesso se atualizar
    # * Renderiza view edit com status 422 se validações falharem
    #
    # ==== Exemplo
    #   PATCH /admin/users/1 # => atualiza e redireciona ou mostra erros
    #
    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Usuário atualizado com sucesso'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    ##
    # Remove um usuário do sistema.
    #
    # ==== Argumentos
    # * Nenhum (usa @user definido pelo before_action)
    #
    # ==== Retorno
    # * Nenhum (redireciona)
    #
    # ==== Efeitos Colaterais
    # * Deleta registro de User do banco de dados (DELETE)
    # * Remove registros relacionados devido a dependent: :destroy nas associações
    # * Redireciona para admin_users_path com mensagem de sucesso
    #
    # ==== Exemplo
    #   DELETE /admin/users/1 # => deleta usuário e redireciona
    #
    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'Usuário deletado com sucesso'
    end

    private

    ##
    # Busca e define o usuário a partir do ID nos parâmetros da URL.
    #
    # ==== Argumentos
    # * Nenhum (usa params[:id])
    #
    # ==== Retorno
    # * Nenhum (define @user)
    #
    # ==== Efeitos Colaterais
    # * Executa query no banco (User.find)
    # * Define variável de instância @user
    # * Levanta ActiveRecord::RecordNotFound se ID não existir
    #
    def set_user
      @user = User.find(params[:id])
    end

    ##
    # Define os parâmetros permitidos para atualização de usuário.
    #
    # ==== Argumentos
    # * Nenhum (usa params do request)
    #
    # ==== Retorno
    # * +ActionController::Parameters+ - parâmetros filtrados e permitidos
    #
    # ==== Efeitos Colaterais
    # * Nenhum (apenas filtragem de parâmetros)
    #
    def user_params
      params.require(:user).permit(:name, :email, :role)
    end

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
