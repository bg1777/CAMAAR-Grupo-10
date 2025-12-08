# app/controllers/admin/users_controller.rb

module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    
    def index
      @users = User.all
    end
    
    def show
    end
    
    def edit
    end
    
    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Usuário atualizado com sucesso'
      else
        render :edit
      end
    end
    
    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'Usuário deletado com sucesso'
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :role)
    end
    
    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
