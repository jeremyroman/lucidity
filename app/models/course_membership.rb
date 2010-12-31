# Represents an instance of a course being planned for in a term.

class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :term
  
  def conflicts
    override ? [] : RequirementChecker.check(course, term)
  end
end
