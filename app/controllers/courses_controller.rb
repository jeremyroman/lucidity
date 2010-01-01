# this creates shim course memberships
# that allow us to reuse the template
class CMShim < Struct.new(:course)
  def satisfied?; true; end
  def id; "new"; end
  def override; false; end
end

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
end
