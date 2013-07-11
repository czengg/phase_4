class Tournament < ActiveRecord::Base
  attr_accessible :active, :date_of_birth, :first_name, :last_name, :phone, :rank
end
