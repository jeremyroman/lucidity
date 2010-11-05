class MainController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  
  def index
    redirect_to root_path if params[:ticket]
  end
  
  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
