require 'test_helper'
require 'performance_test_help'

class PlanGetTest < ActionController::PerformanceTest
  def test_plan_get
    get '/plans/#{Plan.first.id}'
  end
end
