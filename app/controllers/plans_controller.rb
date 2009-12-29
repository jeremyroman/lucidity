class PlansController < ApplicationController
  def show
    @plan = Plan.find(params[:id])
  end
  
  def endpoints
    @plan = Plan.find(params[:id])
    @conflicts = Endpoint.all.map { |e| [e, e.conflicts_with_plan(@plan)] }
  end

  def conflicts
    @plan = Plan.find(params[:id])
    @conflicts = @plan.internal_conflicts
  end
  
  def reorder
    @plan = Plan.find(params[:id])
    
    params[:terms].each do |term_data|
      term = @plan.terms.find(term_data[:term_id])
      
      term_data[:mid].each_with_index do |mid,idx|
        if mid == "new"
          membership = Course.find(term_data[:cid][idx]).course_memberships.build
        else
          membership = @plan.course_memberships.find(mid)
        end
        
        membership.term = term
        membership.position = idx
        membership.save!
      end
    end
    
    render :nothing => true
  end
end
