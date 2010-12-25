class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :userid

      t.timestamps
    end
    
    add_index :users, :userid, :unique => true
  end

  def self.down
    remove_index :users, :column => :userid
    drop_table :users
  end
end
