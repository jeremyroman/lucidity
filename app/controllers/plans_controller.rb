# Handles CRUD actions related to plans

class PlansController < ApplicationController
  # List the current user's plans
  def index
    @plans = current_user.plans
    respond_with(@plans)
  end
  
  # Display a particular plan
  def show
    @plan = current_user.plans.find(params[:id])
    respond_with(@plan)
  end
  
  # Prepare a new plan and display the form
  def new
    @plan = current_user.plans.build
    respond_with(@plan)
  end
  
  # Validate and save a new plan
  def create
    @plan = current_user.plans.build(params[:plan])
    @plan.save
    
    respond_with(@plan)
  end
  
  # Display a form for editing a plan
  def edit
    @plan = current_user.plans.find(params[:id])
    respond_with(@plan)
  end
  
  # Validate and save changes to a plan
  def update
    @plan = current_user.plans.find(params[:id])
    @plan.update_attributes(params[:plan])
    
    respond_with(@plan)
  end
  
  # Destroy a plan
  def destroy
    @plan = current_user.plans.find(params[:id])
    @plan.destroy
    
    respond_with(@plan) do |format|
      format.html { redirect_to root_path }
    end
  end
  
  # Duplicate a plan (and redirect to the new one once done)
  def duplicate
    @plan = current_user.plans.find(params[:id])
    
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
