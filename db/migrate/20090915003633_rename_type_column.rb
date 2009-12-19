class RenameTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :terms, :type, :season
  end

  def self.down
    rename_column :terms, :season, :type
  end
end
