# Join table between Course and Term.
class CourseMembership < ActiveRecord::Base
  belongs_to :course
  belongs_to :term
  acts_as_list :scope => :term
  
  # Returns true if this course membership is
  # valid, and false otherwise.
  def satisfied?
    course.offered?(term) and course.course_requirements.all? { |cr| cr.satisfied?(term, term.plan) }
  end
  
  # Returns an array of conflicts caused by this
  # course membership.
  def conflicts
    (course.offered?(term) ? [] : [course]) +
        course.course_requirements.reject { |cr| cr.satisfied?(term, term.plan) }
  end
end
