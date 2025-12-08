# app/controllers/home_controller.rb

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      redirect_to admin_root_path
    else
      @pending_forms = current_user.pending_forms.order(due_date: :asc)
      @completed_forms = current_user.completed_forms.order(created_at: :desc)
    end
  end
end
