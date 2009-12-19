class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.integer :plan_id
      t.string :type
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
