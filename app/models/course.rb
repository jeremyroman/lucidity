# Represents a course
class Course < ActiveRecord::Base
  has_many :course_requirements, :dependent => :destroy
  has_many :course_group_memberships, :dependent => :destroy
  has_many :course_groups, :through => :course_group_memberships
  has_many :course_memberships, :dependent => :destroy
  has_many :terms, :through => :course_memberships
  
  # Returns a description to be shown when the course is
  # the conflict object. In this case, a message that the
  # course is not offered in the term specified.
  def conflict_description(style=:long)
    "#{code} is only offered in terms #{offered}"
  end
  
  # Returns true if the course is offered in the season
  # given (F for Fall, W for Winter, S for Spring), and
  # false otherwise.
  def offered?(season_or_term)
    offered.include?(season_or_term.is_a?(Term) ? season_or_term.season : season_or_term)
  end
end
