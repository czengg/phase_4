class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :first_name
      t.string :last_name
      t.Date :date_of_birth
      t.string :phone
      t.integer :rank
      t.boolean :active

      t.timestamps
    end
  end
end
