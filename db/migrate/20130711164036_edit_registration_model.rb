class EditRegistrationModel < ActiveRecord::Migration
  def up
  	add_column :registrations, :fee_paid, :boolean
  	add_column :registrations, :final_standing, :integer
  end

  def down
  	remove_column :registrations, :fee_paid
  	remove_column :registrations, :final_standing
  end
end
