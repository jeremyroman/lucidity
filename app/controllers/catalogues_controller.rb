# Handles CRUD actions related to catalogues

class CataloguesController < ApplicationController
  load_and_authorize_resource
  
  # List all catalogues
  def index
    respond_with(@catalogues)
  end
  
  # Display a particular catalogue
  def show
    respond_with(@catalogue) do |format|
      format.html { redirect_to [@catalogue, :courses] }
    end
  end
  
  # Prepare a new catalogue and display the form
  def new
    respond_with(@catalogue)
  end
  
  # Validate and save a new catalogue
  def create
    @catalogue.save
    respond_with(@catalogue)
  end
  
  # Display a form for editing a catalogue
  def edit
    respond_with(@catalogue)
  end
  
  # Validate and save changes to a course
  def update
    @catalogue.update_attributes(params[:catalogue])
    respond_with(@catalogue)
  end
  
  # Destroy a catalogue
  def destroy
    @catalogue.destroy
    respond_with(@catalogue)
  end
end
