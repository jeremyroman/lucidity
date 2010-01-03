# Services requests that pertain to plans.
class PlansController < ApplicationController
  cache_sweeper :course_membership_sweeper, :only => [:reorder]
  caches_action :endpoints
  
  # Renders a single plan.
  def show
    # load the plan *very* eagerly :P
    @plan = Plan.find(params[:id], :include => {:terms => {:course_memberships => {:course => {:course_requirements => {:course_group => {:course_group_memberships => :course}}}}}})
  end
  
  # Shows conflicts between the plan and endpoints.
  def endpoints
    @plan = Plan.find(params[:id])
    @conflicts = Endpoint.all.map { |e| [e, e.conflicts_with_plan(@plan)] }
  end
  
  # Shows internal conflicts within a plan.
  def conflicts
    @plan = Plan.find(params[:id])
    @conflicts = @plan.internal_conflicts
  end
end
