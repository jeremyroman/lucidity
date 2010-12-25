require "application_responder"

# Base class from which all controllers inherit
class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter, :unless => proc { |c| Rails.env == 'test' }
  self.responder = ApplicationResponder
  respond_to :html, :xml, :json
  protect_from_forgery
  
  protected
  
  # Returns the a User model corresponding to the authenticated user
  # (or nil if no user is logged in)
  #
  # @return (User, nil) currently logged in user, or nil
  def current_user
    return nil if session[:cas_user].nil?
    @current_user ||= User.find_or_initialize_by_userid(session[:cas_user])
    
    if @current_user.new_record?
      flash.now[:warning] = t(:disclaimer)
      @current_user.save!
    end
    
    @current_user
  end
  
  helper_method :current_user
end
