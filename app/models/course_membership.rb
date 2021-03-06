# Represents an instance of a course being planned for in a term.

class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :term
  
  attr_accessible :course_id, :override
  validates_presence_of :course_id, :term_id
  
  def conflicts
    override ? [] : RequirementChecker.check(course, term)
  end
end
