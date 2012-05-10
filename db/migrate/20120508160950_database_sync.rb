class DatabaseSync < ActiveRecord::Migration
  def up
      add_column :albums, :reference, :string
	  add_column :albums, :catalognumber, :string
	  add_column :artists, :reference, :string
	  add_column :sources, :reference, :string
  end

  def down
      remove_column :albums, :reference
	  remove_column :albums, :catalognumber
	  remove_column :artists, :reference
	  remove_column :sources, :reference  
  end
end
