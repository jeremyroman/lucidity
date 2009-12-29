# this creates shim course memberships
# that allow us to reuse the template
class CMShim < Struct.new(:course)
  def satisfied?; true; end
  def id; "new"; end
end

class CoursesController < ApplicationController
  def show
    @course = Course.find(params[:id])
  end
  
  def search
    query = params[:query]
    @courses = Course.find(:all, :limit => 6, :conditions => 
      ["code LIKE ? OR name LIKE ?", "#{query}%", "%#{query}%"])
    
    @shims = @courses.map { |c| CMShim.new(c) }
  end
end
