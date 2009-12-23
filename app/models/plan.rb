# Represents a planned course schedule
class Plan < ActiveRecord::Base
  has_many :terms, :dependent => :destroy
  has_many :courses, :through => :terms
  
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
        retval << course unless course.offered?(term.season)
        retval += course.course_requirements.reject { |cr| cr.satisfied?(term, self) }
      end
    end
    
    retval
  end
  
  # the following stuff is mostly for usage in script/console
  # and does not need to be covered by tests
  
  #:nocov:
  
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
  
  #:nocov:
end
