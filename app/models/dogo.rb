class Dogo < ActiveRecord::Base
  attr_accessible :active, :city, :latitude, :longitude, :name, :state, :street, :zip
end
