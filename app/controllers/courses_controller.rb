# Handles CRUD actions related to courses

class CoursesController < ApplicationController
  load_and_authorize_resource :catalogue, :only => [:index, :new, :create]
  load_and_authorize_resource :course, :through => :catalogue, :only => [:index, :new, :create]
  load_and_authorize_resource :course, :except => [:index, :new, :create]
  
  caches_action :show, :if => proc { |c| c.request.xhr? }
  
  # List all courses
  def index
    respond_with(@courses)
  end
  
  # Display a particular course
  def show
    respond_with(@course)
  end
  
  # Prepare a new course and display the form
  def new
    respond_with(@course)
  end
  
  # Validate and save a new course
  def create
    @course.save
    respond_with(@course)
  end
  
  # Display a form for editing a course
  def edit
    respond_with(@course)
  end
  
  # Validate and save changes to a course
  def update
    @course.update_attributes(params[:course])
    respond_with(@course)
  end
  
  # Destroy a course
  def destroy
    @course.destroy
    
    respond_with(@course) do |format|
      format.html { redirect_to [@course.catalogue, :courses] }
    end
  end
  
  def search
    conditions = ["code LIKE ? OR name LIKE ?", "#{params[:q]}%", "%#{params[:q]}%"]
    count = Course.count(:conditions => conditions)
    
    if count > 20
      render :text => ""
    else
      @courses = Course.find(:all, :conditions => conditions)
      render :layout => false
    end
  end
end
