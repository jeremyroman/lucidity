# Services requests which pertain to course memberships
# and are not handled by other classes such as
# PlansController.
class CourseMembershipsController < ApplicationController
  cache_sweeper :course_membership_sweeper
  
  # Removes a course membership.
  def destroy
    @cm = CourseMembership.find(params[:id])
    @cm.destroy
    
    render :nothing => true
  end
  
  # Updates a course membership.
  def update
    @cm = CourseMembership.find(params[:id])
    @cm.update_attributes(params[:course_membership])
    
    render :nothing => true
  end
  
  # This action serves to handle not only reordering,
  # but also the addition of new courses to the plan.
  def reorder
    @plan = Plan.find(params[:plan_id])
    
    params[:terms].each do |term_data|
      term = @plan.terms.find(term_data[:term_id])
      
      term_data[:memberships].each_with_index do |mem,idx|
        if mem[:mid] =~ /^new/
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
