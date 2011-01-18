class ChangeRequirementsToText < ActiveRecord::Migration
  def self.up
    change_column :courses, :requirements, :text
  end

  def self.down
    change_column :courses, :requirements, :string
  end
end