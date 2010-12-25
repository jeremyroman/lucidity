class CreateCatalogues < ActiveRecord::Migration
  def self.up
    create_table :catalogues do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :courses, :catalogue_id, :integer
  end

  def self.down
    remove_column :courses, :catalogue_id
    drop_table :catalogues
  end
end