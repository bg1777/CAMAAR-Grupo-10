# app/controllers/admin/dashboard_controller.rb

module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    
    def index
      @users = User.all
      @total_users = User.count
      @admin_count = User.where(role: :admin).count
    end
    
    private
    
    def check_admin
      redirect_to root_path, alert: 'Acesso negado!' unless current_user.admin?
    end
  end
end
