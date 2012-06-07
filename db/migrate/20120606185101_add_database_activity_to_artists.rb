class AddDatabaseActivityToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :database_activity, :string
    add_column :sources, :database_activity, :string
  end
end
