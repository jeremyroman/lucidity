class CreateCourseGroups < ActiveRecord::Migration
  def self.up
    create_table :course_groups do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :course_groups
  end
end
