class EditSectionModel < ActiveRecord::Migration
  def up
  	add_column :sections, :tournament_id, :integer
  	add_column :sections, :round_time, :time
  	add_column :sections, :location, :string
  end

  def down
  	remove_column :sections, :tournament_id
  	remove_column :sections, :round_time
  	remove_column :sections, :location
  end
end
