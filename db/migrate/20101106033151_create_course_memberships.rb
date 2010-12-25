class CreateCourseMemberships < ActiveRecord::Migration
  def self.up
    create_table :course_memberships do |t|
      t.integer :course_id
      t.integer :term_id
      t.boolean :override
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :course_memberships
  end
end
