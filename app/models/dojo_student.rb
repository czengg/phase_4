class DojoStudent < ActiveRecord::Base
  attr_accessible :dojo_id, :end_date, :start_date, :student_id
end
