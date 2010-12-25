# Handles CRUD actions related to catalogues
# 
# TODO: Restrict to administrators

class CataloguesController < ApplicationController
  # List all catalogues
  def index
    @catalogues = Catalogue.all
    respond_with(@catalogues)
  end
  
  # Display a particular catalogue
  def show
    @catalogue = Catalogue.find(params[:id])
    
    respond_with(@catalogue) do |format|
      format.html { redirect_to [@catalogue, :courses] }
    end
  end
  
  # Prepare a new catalogue and display the form
  def new
    @catalogue = Catalogue.new
    respond_with(@catalogue)
  end
  
  # Validate and save a new catalogue
  def create
    @catalogue = Catalogue.new(params[:catalogue])
    @catalogue.save
    
    respond_with(@catalogue)
  end
  
  # Display a form for editing a catalogue
  def edit
    @catalogue = Catalogue.find(params[:id])
    respond_with(@catalogue)
  end
  
  # Validate and save changes to a course
  def update
    @catalogue = Catalogue.find(params[:id])
    @catalogue.update_attributes(params[:catalogue])
    
    respond_with(@catalogue)
  end
  
  # Destroy a catalogue
  def destroy
    @catalogue = Catalogue.find(params[:id])
    @catalogue.destroy
    
    respond_with(@catalogue)
  end
end
