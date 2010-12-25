# Handles centralized actions which don't correspond to a particular resource.

class MainController < ApplicationController
  # Displays the landing page
  def index
    redirect_to root_path if params[:ticket]
  end
  
  # Logs the current user out of CAS
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
