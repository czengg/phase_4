class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :date
      t.integer :min_rank, :default => 1
      t.integer :max_rank, :default => 15
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
