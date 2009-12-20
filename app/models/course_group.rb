class CourseGroup < ActiveRecord::Base
  has_many :course_group_memberships
  has_many :courses, :through => :course_group_memberships
  has_one :endpoint_requirement
  has_one :course_requirement
end
