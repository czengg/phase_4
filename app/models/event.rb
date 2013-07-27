class Event < ActiveRecord::Base
  attr_accessible :active, :name
  
  # Relationships
  has_many :sections
  has_many :registrations, :through => :sections
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('events.active = ?', true)
  scope :inactive, where('events.active = ?', false)
  
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false" 
    
  #Callbacks
  before_destroy :check_if_destroyable
  after_rollback :end_event_now

  def check_if_destroyable
    if self.sections.active.empty?
      return true
    else
      return false
    end
  end

  def end_event_now
    self.sections.active.each{ |s| s.destroy }
    self.active = false
    self.save!
  end
end
