class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :activity
      t.boolean :obtained

      t.timestamps
    end
  end
end
