class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string :name
      t.string :season
      t.integer :plan_id

      t.timestamps
    end
    
    add_index :terms, :plan_id
  end

  def self.down
    remove_index :terms, :plan_id
    drop_table :terms
  end
end
