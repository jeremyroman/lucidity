class AddPositionToCourseMembership < ActiveRecord::Migration
  def self.up
    add_column :course_memberships, :position, :integer
  end

  def self.down
    remove_column :course_memberships, :position
  end
end
