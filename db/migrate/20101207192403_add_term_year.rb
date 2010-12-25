class AddTermYear < ActiveRecord::Migration
  def self.up
    add_column :terms, :year, :integer
    remove_column :terms, :name
  end

  def self.down
    add_column :terms, :name, :string
    remove_column :terms, :year
  end
end
