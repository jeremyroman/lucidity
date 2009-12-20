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
  def conflict_description
    "#{code} is only offered in terms #{offered}"
  end
end
