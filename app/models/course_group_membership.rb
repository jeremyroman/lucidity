# Join table between Course and CourseGroup.
class CourseGroupMembership < ActiveRecord::Base
  belongs_to :course_group, :touch => true
  belongs_to :course
end
