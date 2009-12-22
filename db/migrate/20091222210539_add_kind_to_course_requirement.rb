class AddKindToCourseRequirement < ActiveRecord::Migration
  def self.up
    add_column :course_requirements, :kind, :string
  end

  def self.down
    remove_column :course_requirements, :kind
  end
end
