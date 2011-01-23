class AdminController < ApplicationController
  before_filter proc { |c| raise CanCan::AccessDenied unless c.current_user.admin? }
  
  def switch_user
    sign_in :user, User.find_by_username!(params[:username])
    redirect_to root_path
  end
end
