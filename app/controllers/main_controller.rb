# This controller handles general things that don't really
# fit anywhere else. This includes things like serving the
# main UI.
class MainController < ApplicationController
  caches_action :index
  
  # Serves the main UI.
  def index
    @plans = Plan.all
  end
end
