# Adds and removes courses from terms

class CourseMembershipsController < ApplicationController
  respond_to :json
  self.responder = ActionController::Responder
  
  def create
    @course_membership = CourseMembership.new(params[:course_membership])
    @course_membership.save
    
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:course_membership => @course_membership, :conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
  
  def destroy
    @course_membership = CourseMembership.find_by_term_id_and_course_id(params[:term_id], params[:course_id])
    @course_membership.destroy
    
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
  
  def edit
    @course_membership = CourseMembership.find_by_term_id_and_course_id(params[:term_id], params[:course_id])
    respond_to { |format| format.html }
  end
  
  def update
    @course_membership = CourseMembership.find(params[:id])
    @course_membership.update_attributes(params[:course_membership])
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:course_membership => @course_membership, :conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
end
