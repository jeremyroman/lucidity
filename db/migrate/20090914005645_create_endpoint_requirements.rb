class CreateEndpointRequirements < ActiveRecord::Migration
  def self.up
    create_table :endpoint_requirements do |t|
      t.integer :endpoint_id
      t.integer :course_group_id
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :endpoint_requirements
  end
end
