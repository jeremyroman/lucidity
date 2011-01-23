require "application_responder"

# Base class from which all controllers inherit
class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  
  self.responder = ApplicationResponder
  respond_to :html, :json
  
  layout proc { |c| c.request.xhr? ? false : 'application' }
end
