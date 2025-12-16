# app/controllers/application_controller.rb

##
# Controller base da aplicação, do qual todos os outros controllers herdam.
# Define configurações e comportamentos compartilhados por toda a aplicação.
#
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
