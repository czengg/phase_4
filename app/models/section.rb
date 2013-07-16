class Section < ActiveRecord::Base
  attr_accessible :active, :event_id, :min_age, :min_rank, :max_age, :max_rank, :tournament_id, :location, :round_time
  
  # Relationships
  belongs_to :event
  has_many :registrations
  has_many :students, :through => :registrations
  belongs_to :tournament
  
  # Scopes
  scope :for_event, lambda {|event_id| where("event_id = ?", event_id) }
  scope :for_rank, lambda {|desired_rank| where("min_rank <= ? and (max_rank >= ? or max_rank is null)", desired_rank, desired_rank) }
  scope :for_age, lambda {|desired_age| where("min_age <= ? and (max_age >= ? or max_age is null)", desired_age, desired_age) }
  scope :active, where('sections.active = ?', true)
  scope :inactive, where('sections.active = ?', false)
  scope :alphabetical, joins(:event).order('events.name, min_rank, min_age')
  scope :for_location, lambda{|l| where("location = ?", l)}
  scope :by_location, order('location')
  scope :for_tournament, lambda{|t| where('tournament_id = ?', t)}
  
  # Validations
  validates_presence_of :tournament_id, :event_id, :min_age, :min_rank 
  validates_numericality_of :min_rank, :only_integer => true, :greater_than_or_equal_to => :tournament_min_rank
  validates_numericality_of :max_rank, :only_integer => true, :greater_than_or_equal_to => :min_rank, :less_than_or_equal_to => :tournament_max_rank, :allow_blank => true
  validates_numericality_of :min_age, :only_integer => true, :greater_than_or_equal_to => 5
  validates_numericality_of :max_age, :only_integer => true, :greater_than_or_equal_to => :min_age, :allow_blank => true
  validates_numericality_of :event_id, :only_integer => true, :greater_than => 0, :message => "is not a valid event"
  validates_numericality_of :tournament_id, :only_integer => true, :greater_than => 0, :message => "is not a valid tournament"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"

  validate :event_is_active_in_system
  validate :section_is_not_already_in_system, :on => :create
  validate :tournament_is_active_in_system

  # Not needed unless going the long route with registrations
  # def to_s
  #   "#{self.event.name} => #{self.min_rank}-#{self.max_rank} => #{self.min_age}-#{self.max_age}"
  # end

  #Callbacks
  # before_destroy :check_if_destroyable

  def tournament_min_rank
    if tournament_is_active_in_system
      active_tournament_ids = Tournament.active.all.map{|t| t.id}
      active_tournament_ids.each do |i|
        if i == self.tournament_id
          return min_rank
        end
      end
    end
    return
  end

  def tournament_max_rank
    if tournament_is_active_in_system
      active_tournament_ids = Tournament.active.all.map{|t| t.id}
      active_tournament_ids.each do |i|
        if i == self.tournament_id
          return max_rank
        end
      end
    end
    return
  end

  def have_registrations 
    registration_ids = Registration.all.map{|r| r.id}
    return !registration_ids.empty?
  end

  def check_if_destroyable
    if section_empty? == false
      self.active = false
      self.save!
      return false
    else
      self.destroy
      self.save!
      return true
    end
  end

  def section_empty?
    if self.sections.registration
      return false
    else
      return true
    end
  end

  private
  def event_is_active_in_system
    # get an array of all active events in the system
    active_events_ids = Event.active.all.map{|e| e.id}
    # add error unless the event id of the section is in the array of active events
    unless active_events_ids.include?(self.event_id)
      errors.add(:event, "is not an active event in the system")
      return false
    end
    return true
  end
  
  def section_is_not_already_in_system
    possible_repeat = Section.where(:event_id => self.event_id, :tournament_id => self.tournament_id, :min_age => self.min_age, :min_rank => self.min_rank)
    # alternate method would be using the dynamic find_by method...
    # possible_repeat = Section.find_by_event_id_and_min_age_and_min_rank(self.event_id, self.min_age, self.min_rank)
    unless possible_repeat.empty?  # use .nil? if using find_by as it only returns one object, not an array
      errors.add(:min_rank, "already has a section for this event, tournament, age and rank")
    end
  end

  def tournament_is_active_in_system
    active_tournament_ids = Tournament.active.all.map{|t| t.id}
    unless active_tournament_ids.include?(self.tournament_id)
      errors.add(:tournament, "is not an active tournament in the system")
      return false
    end
    return true
  end

end
