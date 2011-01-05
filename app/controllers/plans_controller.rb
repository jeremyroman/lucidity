# Handles CRUD actions related to plans

class PlansController < ApplicationController
  load_and_authorize_resource
  
  # List the current user's plans
  def index
    respond_with(@plans)
  end
  
  # Display a particular plan
  def show
    t1 = Time.now
    @conflicts = @plan.conflicts.map { |c| c.delete(:message); c }
    Rails.logger.debug("\033[43m\033[1mConflicts computed in #{Time.now-t1} seconds.\033[0m")
    respond_with(@plan)
  end
  
  # Prepare a new plan and display the form
  def new
    respond_with(@plan)
  end
  
  # Validate and save a new plan
  def create
    @plan.save
    
    respond_with(@plan)
  end
  
  # Display a form for editing a plan
  def edit
    respond_with(@plan)
  end
  
  # Validate and save changes to a plan
  def update
    @plan.update_attributes(params[:plan])
    
    respond_with(@plan)
  end
  
  # Destroy a plan
  def destroy
    @plan.destroy
    
    respond_with(@plan) do |format|
      format.html { redirect_to root_path }
    end
  end
  
  # Duplicate a plan (and redirect to the new one once done)
  def duplicate
    if request.post?
      @plan = @plan.duplicate
      @plan.update_attributes(params[:plan])
      redirect_to @plan
    else
      @plan.name += " (Copy)"
      respond_with(@plan)
    end
  end
end
