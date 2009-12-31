class AddOverrideToCourseMemberships < ActiveRecord::Migration
  def self.up
    add_column :course_memberships, :override, :boolean
  end

  def self.down
    remove_column :course_memberships, :override
  end
end
