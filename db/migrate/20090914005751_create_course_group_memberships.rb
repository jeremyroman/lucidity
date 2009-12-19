class CreateCourseGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :course_group_memberships do |t|
      t.integer :course_group_id
      t.integer :course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :course_group_memberships
  end
end
