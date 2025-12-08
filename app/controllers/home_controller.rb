# app/controllers/home_controller.rb

class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.admin?
      redirect_to admin_root_path
    else
      @user = current_user
    end
  end
end
