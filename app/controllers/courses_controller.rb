# Services requests which pertains to courses
# in general.
class CoursesController < ApplicationController
  # Displays information about a given course.
  def show
    @course = Course.find(params[:id])
  end
  
  # Searches for courses based on a supplied query.
  def search
    query = params[:query]
    @courses = Course.find(:all, :limit => 6, :conditions => 
      ["code LIKE ? OR name LIKE ?", "#{query}%", "%#{query}%"])
  end
  
  # Provides autocompletion
  def autocomplete
    query = params[:q]
    @courses = Course.find(:all, :limit => 20, :conditions => 
      ["code LIKE ?", "#{query}%"])
      
    render :text => @courses.map { |c| "#{c.code}|#{c.name}\n" }.join
  end
  
  # Shows a list of courses.
  def index
    @courses = Course.all(:order => "code")
  end
  
  # Shows the form for creating a new course.
  def new
    @course = Course.new
    @course.course_requirements.build
  end
  
  # Creates a new course.
  def create
    @course = Course.new(params[:course])
    
    if @course.save
      flash[:notice] = "Course created"
      redirect_to @course
    else
      render :action => "new"
    end
  end
  
  # Shows the form for editing a course.
  def edit
    @course = Course.find(params[:id])
  end
  
  # Commits changes to a course
  def update
    @course = Course.find(params[:id])
    
    if @course.update_attributes(params[:course])
      flash[:notice] = "Course saved"
      redirect_to @course
    else
      render :action => "edit"
    end
  end
  
  # Destroys a course.
  def destroy
    @course = Course.find(params[:id])
    
    if @course.destroy
      flash[:notice] = "Course deleted."
    end
    
    redirect_to courses_path
  end
end
