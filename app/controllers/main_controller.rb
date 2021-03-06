# Handles centralized actions which don't correspond to a particular resource.

class MainController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :logout
  
  # Logs the user out
  def logout
    Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
  end
end
