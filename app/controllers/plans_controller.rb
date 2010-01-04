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
  
  # Reorder plans
  def reorder
    params[:plans].each_with_index do |plan_id, idx|
      Plan.update(plan_id, :position => idx)
    end
    
    render :nothing => true
  end
  
  # Displays the new plan form.
  def new
    @plan = Plan.new
    
    # pre-generate the sequence for regular students
    [%w(1A F), %w(1B W), %w(2A F), %w(2B W), %w(3A F), %w(3B W), %w(4A F), %w(4B W)].each do |name, season|
      @plan.terms.build(:name => name, :season => season)
    end
  end
  
  # Creates a new plan.
  def create
    @plan = Plan.new(params[:plan])
    
    if @plan.save
      @newplan = @plan
      new
    end
    
    render :action => "new"
  end
  
  # Displays the form for editing a plan.
  def edit
    @plan = Plan.find(params[:id])
  end
  
  # Updates a plan.
  def update
    @plan = Plan.find(params[:id])
    @plan.update_attributes(params[:plan])
    redirect_to root_path
  end
  
  # Deletes a plan.
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to root_path
  end
end
