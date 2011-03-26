# Adds and removes courses from terms

class CourseMembershipsController < ApplicationController
  load_and_authorize_resource :term
  load_resource :course_membership, :through => :term
  
  respond_to :json
  self.responder = ActionController::Responder
  
  def create
    @course_membership.save!
    
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:course_membership => @course_membership, :conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
  
  def destroy
    @course_membership.destroy
    
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
  
  def edit
    respond_to { |format| format.html }
  end
  
  def update
    @course_membership.update_attributes!(params[:course_membership])
    respond_with(@course_membership) do |format|
      format.json do
        render :json => {:course_membership => @course_membership, :conflicts => @course_membership.term.plan.conflicts }.to_json
      end
    end
  end
end
