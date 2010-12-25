# Adds and removes courses from terms

class CourseMembershipsController < ApplicationController
  respond_to :xml, :json
  
  def create
    @course_membership = @term.course_memberships.build(params[:course_membership])
    @course_membership.save
    
    respond_with(@course_membership)
  end
  
  def destroy
    @course_membership = @term.course_memberships.find(params[:id])
    @course_membership.destroy
    
    respond_with(@course_membership)
  end
end
