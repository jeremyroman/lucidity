class AddCourseRequirement < ActiveRecord::Migration
  def self.up
    add_column :courses, :requirements, :string
  end

  def self.down
    remove_column :courses, :requirements
  end
end