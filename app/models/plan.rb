# Represents a planned course schedule
class Plan < ActiveRecord::Base
  has_many :terms
  has_many :courses, :through => :terms
    
  # Returns true is the plan satisfies all of the
  # endpoint requirements, and false otherwise.
  def satisfies_endpoint?(endpoint)
    conflicts_with_endpoint(endpoint).empty?
  end
  
  # Returns a list of conflicts with a given endpoint.
  # Each element will implement #conflict_description.
  def conflicts_with_endpoint(endpoint)
    retval = []
    
    endpoint.endpoint_requirements.each do |endpoint_requirement|
      retval << endpoint_requirement unless endpoint_requirement.satisfied?(self)
    end
    
    retval
  end
  
  # Returns true if the plan has no internal conflicts
  # (that is, all courses have their prerequisites satisfied),
  # and false otherwise.
  def internally_consistent?
    internal_conflicts.empty?
  end
  
  # Retruns a list of internal conflicts.
  # Each element will implement #conflict_description.
  def internal_conflicts
    retval = []
    
    terms.each do |term|
      term.courses.each do |course|
        retval << course unless course.offered.include?(term.season)
        
        course.course_requirements.each do |course_requirement|
          retval << course_requirement unless course_requirement.satisfied?(term, self)
        end
      end
    end
    
    retval
  end
  
  # Prints internal conflicts to stdout.
  def print_internal_conflicts
    internal_conflicts.each { |con| puts con.conflict_description }
    nil
  end
  
  # Prints endpoint conflicts to stdout.
  def print_conflicts_with_endpoint(endpoint)
    conflicts_with_endpoint(endpoint).each { |con| puts con.conflict_description }
    nil
  end
  
  # Prints a summary of the plan.
  # Intended for use in script/console and other
  # times when a fixed-width font is used.
  def summ
    terms.each do |term|
      printf "%s/%s: ", term.name, term.season
      term.courses.each { |c| print c.code.ljust(10) }
      print "\n"
    end

    nil
  end
end
