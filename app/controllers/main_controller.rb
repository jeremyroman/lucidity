# This controller handles general things that don't really
# fit anywhere else. This includes things like serving the
# main UI.
class MainController < ApplicationController
  # this could also be done as caches_page,
  # but then I'd have to remember to remove
  # index.html whenever I switched to the
  # development environment. :)
  caches_action :index
  
  # Serves the main UI.
  def index
    @plans = Plan.all
  end
end
