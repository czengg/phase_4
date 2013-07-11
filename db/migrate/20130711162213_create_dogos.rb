class CreateDogos < ActiveRecord::Migration
  def change
    create_table :dogos do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.boolean :active

      t.timestamps
    end
  end
end
