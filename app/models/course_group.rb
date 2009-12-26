# Represents a group of courses, used mostly
# for prerequisites which specify "2 of..." or
# something similar.
class CourseGroup < ActiveRecord::Base
  has_many :course_group_memberships, :dependent => :destroy
  has_many :courses, :through => :course_group_memberships
  has_one :endpoint_requirement
  has_one :course_requirement
  
  # friendly way to convert a the course group
  # to a user-readable string
  def to_s
    courses.map(&:code).to_sentence
  end
end
