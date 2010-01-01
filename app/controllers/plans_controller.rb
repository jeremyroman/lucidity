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
  
  # Updates a plan. This action serves to handle not only reordering,
  # but also the addition of new courses to the plan.
  def reorder
    @plan = Plan.find(params[:id])
    
    params[:terms].each do |term_data|
      term = @plan.terms.find(term_data[:term_id])
      
      term_data[:memberships].each_with_index do |mem,idx|
        if mem[:mid] == "new"
          membership = Course.find(mem[:cid]).course_memberships.build
        else
          membership = @plan.course_memberships.find(mem[:mid])
        end
        
        membership.term = term
        membership.override = mem[:override]
        membership.position = idx
        membership.save! if membership.changed?
      end
    end
    
    render :nothing => true
  end
end
