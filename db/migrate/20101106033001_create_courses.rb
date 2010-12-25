class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.string :offered
      t.text :description

      t.timestamps
    end
    
    add_index :courses, :code
  end

  def self.down
    remove_index :courses, :code
    drop_table :courses
  end
end
