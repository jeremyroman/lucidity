class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
    
    add_index :plans, :user_id
  end

  def self.down
    remove_index :plans, :user_id
    drop_table :plans
  end
end
