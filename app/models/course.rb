class Course < ActiveRecord::Base
  has_many :course_requirements
  has_many :course_group_memberships
  has_many :course_groups, :through => :course_group_memberships
  has_many :course_memberships
  has_many :terms, :through => :course_memberships
  
  def conflict_description
    "#{code} is only offered in terms #{offered}"
  end
end
