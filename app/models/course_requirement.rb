# Specifies requirements (e.g. prerequisites) for entry
# into a course.
class CourseRequirement < ActiveRecord::Base
  belongs_to :course, :touch => true
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
      # FIXME: implement this better
      plan.terms.any? do |t|
        if prerequisite?
          op = "<"
        elsif corequisite?
          op = "<="
        end
        
        plan.terms.count(:include => :courses, :conditions => ["courses.id = ? AND terms.id #{op} ?", course, term]) > 0
      end
    end.size >= number
  end
  
  # Returns a description of the conflict (that is, that
  # the requirement is not satisfied)
  def conflict_description(style=:long)
    prefix = (style == :short) ? "" : "#{course.code} "
    
    if prerequisite? and number == course_group.courses.size
      "#{prefix}prerequisite: #{course_group}"
    elsif prerequisite?
      "#{prefix}prerequisite: #{number} of #{course_group}"
    elsif corequisite? and number == course_group.courses.size
      "#{prefix}corequisite: #{course_group}"
    elsif corequisite?
      "#{prefix}corequisite: #{number} of #{course_group}"
    elsif antirequisite?
      "#{prefix}antirequisite: #{course_group}"
      
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
  
  # Returns a string representation of the course group
  # in a form appropriate for editing.
  def course_group_string
    return "" if course_group.nil?
    course_group.courses.map(&:code).join(", ")
  end
  
  # Applies changes to the string representation of the
  # course group to the model.
  def course_group_string=(cgs)
    build_course_group if course_group.nil?
    course_group.courses = Course.find_all_by_code(cgs.split(/ *(,|,? and ) */))
  end
end
