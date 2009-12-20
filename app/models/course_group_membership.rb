class CourseGroupMembership < ActiveRecord::Base
  belongs_to :course_group
  belongs_to :course
end
