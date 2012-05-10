class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.date :releasedate
      t.string :genre
      t.string :publisher
      t.boolean :albumobtained

      t.timestamps
    end
  end
end
