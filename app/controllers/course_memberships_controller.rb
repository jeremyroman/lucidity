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
end
