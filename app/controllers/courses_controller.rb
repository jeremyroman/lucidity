# Handles CRUD actions related to courses
# 
# TODO: Restrict to administrators

class CoursesController < ApplicationController
  before_filter proc { |c| @catalogue = Catalogue.find(c.params[:catalogue_id]) }, :only => [:index, :new, :create]
  
  # List all courses
  def index
    @courses = @catalogue.courses
    respond_with(@courses)
  end
  
  # Display a particular course
  def show
    @course = Course.find(params[:id])
    respond_with(@course)
  end
  
  # Prepare a new course and display the form
  def new
    @course = @catalogue.courses.build
    respond_with(@course)
  end
  
  # Validate and save a new course
  def create
    @course = @catalogue.courses.build(params[:course])
    @course.save
    
    respond_with(@course)
  end
  
  # Display a form for editing a course
  def edit
    @course = Course.find(params[:id])
    respond_with(@course)
  end
  
  # Validate and save changes to a course
  def update
    @course = Course.find(params[:id])
    @course.update_attributes(params[:course])
    
    respond_with(@course)
  end
  
  # Destroy a course
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    
    respond_with(@course) do |format|
      format.html { redirect_to [@course.catalogue, :courses] }
    end
  end
  
  def search
    conditions = ["code LIKE ? || '%' OR name LIKE '%' || ? || '%'", params[:q], params[:q]]
    count = Course.count(:conditions => conditions)
    
    if count > 20
      render :text => ""
    else
      @courses = Course.find(:all, :conditions => conditions)
      render :layout => false
    end
  end
end
