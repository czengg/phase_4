class CreateDojoStudents < ActiveRecord::Migration
  def change
    create_table :dojo_students do |t|
      t.integer :dojo_id
      t.integer :student_id
      t.Date :start_date
      t.Date :end_date

      t.timestamps
    end
  end
end
