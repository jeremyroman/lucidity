class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.cas_authenticatable
      t.trackable
      t.timestamps
    end

    add_index :users, :username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
