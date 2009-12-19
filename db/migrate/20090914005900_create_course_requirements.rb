class CreateCourseRequirements < ActiveRecord::Migration
  def self.up
    create_table :course_requirements do |t|
      t.integer :course_id
      t.integer :course_group_id
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :course_requirements
  end
end
