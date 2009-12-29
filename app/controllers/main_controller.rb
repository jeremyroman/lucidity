# This controller handles general things that don't really
# fit anywhere else. This includes things like serving the
# main UI.
class MainController < ApplicationController
  # Serves the main UI.
  def index
    if AppConfig.lazy_load_plans
      @plans = Plan.all
    else
      @plans = Plan.find(:all, :include => {:terms => {:course_memberships => :course}})
    end
  end
end
