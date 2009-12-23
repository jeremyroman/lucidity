class AddLongDescriptionToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :long_description, :text
  end

  def self.down
    remove_column :courses, :long_description
  end
end
