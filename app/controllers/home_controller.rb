# app/controllers/home_controller.rb

class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_root_path
      else
        @user = current_user
      end
    end
  end
end
