class AddPositionToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :position, :integer
  end

  def self.down
    remove_column :plans, :position
  end
end
