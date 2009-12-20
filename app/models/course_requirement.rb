# Specifies requirements (e.g. prerequisites) for entry
# into a course.
class CourseRequirement < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_group
  
  # Returns true is the requirement is satisfied by the plan given
  # if the course is taken in a specific term, and false otherwise.
  def satisfied?(term, plan)
    course_group.courses.select do |course|
      term2 = plan.terms.detect { |t| t.courses.include? course }
      term2 && (term2.id < term.id)
    end.size >= number
  end
  
  # Returns a description of the conflict (that is, that
  # the requirement is not satisfied)
  def conflict_description
    "#{course.code} requires #{number} of: #{course_group.courses.map(&:code).join(', ')}"
  end
end
