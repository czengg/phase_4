class Dojo < ActiveRecord::Base
  attr_accessible :active, :city, :latitude, :longitude, :name, :state, :street, :zip

  #Relationships
  has_many :dojo_students

  #Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :by_state, order('state')

  #Constants
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]
  
  #Validations
  validates_presence_of :name, :street, :zip
  validates_inclusion_of :state, :in => STATES_LIST.map {|key, value| value}, :message => "is not an option", :allow_nil => true, :allow_blank => true
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long", :allow_blank => false
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  validate :dojo_name_is_already_in_system

  #Callbacks
  before_save :find_dojo_coordinates
  before_destroy :check_if_destroyable
  after_rollback :end_dojo_now

  def check_if_destroyable
    if self.dojo_students.empty?
      return true
    else
      return false
    end
  end

  def delete_dojo_now
    self.dojo_students.each{ |d| d.destroy }
    self.active = false
    self.save!
  end

  private
  def find_dojo_coordinates
    coord = Geocoder.coordinates("#{name}, #{state}")
    if coord
      self.latitude = coord[0]
      self.longitude = coord[1]
    else
      errors.add(:base, "Error with geocoding")
    end
    coord
  end

  def dojo_name_is_already_in_system
    all_dojo_names = Dojo.all.map{|d| d.name}

    if all_dojo_names.empty?
      return true
    else
      all_dojo_names.each{|n| n.downcase!}
      if all_dojo_names.include?(self.name.downcase)
        errors.add(:dojo, "is already in the system")
        return false
      end
      return true
    end
  end

end
