# Handles centralized actions which don't correspond to a particular resource.

class MainController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :logout
  
  # Displays the landing page
  def index
    redirect_to root_path if params[:ticket]
  end
  
  # Logs the user out
  def logout
    Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
  end
end
