# Specifies requirements (e.g. prerequisites) for entry
# into a course.
class CourseRequirement < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_group, :dependent => :destroy
  
  # Returns true is the requirement is satisfied by the plan given
  # if the course is taken in a specific term, and false otherwise.
  def satisfied?(term, plan)
    # handle anti-requisite courses
    if antirequisite?
      return ! course_group.courses.any? do |course|
        plan.terms.any? { |term| term.courses.include?(course) }
      end
    end
    
    # handle pre- and co-requisite courses
    course_group.courses.select do |course|
      term2 = plan.terms.detect { |t| t.courses.include? course }
      
      # TODO: Use a better comparator than the primary key
      if prerequisite?
        term2 && (term2.id < term.id)
      elsif corequisite?
        term2 && (term2.id <= term.id)
      end
    end.size >= number
  end
  
  # Returns a description of the conflict (that is, that
  # the requirement is not satisfied)
  def conflict_description(style=:long)
    if prerequisite? and number == course_group.courses.size
      "#{course.code} prerequisite: #{course_group}"
    elsif prerequisite?
      "#{course.code} prerequisite: #{number} of #{course_group}"
    elsif corequisite? and number == course_group.courses.size
      "#{course.code} corequisite: #{course_group}"
    elsif corequisite?
      "#{course.code} corequisite: #{number} of #{course_group}"
    elsif antirequisite?
      "#{course.code} antirequisite: #{course_group}"
      
    # this should never be reached
    #:nocov:
    else
      "Corrupt data. Please contact the system administrator."
      #:nocov:
    end
  end
  
  # Returns true if the requirement is a prerequisite,
  # and false otherwise.
  def prerequisite?
    kind == "prereq" || kind.blank?
  end
  
  # Returns true if the requirement is a corequisite,
  # and false otherwise.
  def corequisite?
    kind == "coreq"
  end
  
  # Returns true if the requirement is an antirequisite,
  # and false otehrwise.
  def antirequisite?
    kind == "antireq"
  end
end
