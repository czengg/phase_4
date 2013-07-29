class Tournament < ActiveRecord::Base
  attr_accessible :active, :name, :date, :min_rank, :max_rank

  #Relationships
  has_many :sections

  #Scopes
  scope :chronological, order('date')
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  scope :past, where('date < ?', Date.today)
  scope :upcoming, where('date >= ?', Date.today)
  scope :next, lambda { |offset| { :conditions => ['id > ?', :id], :offset => offset, :order => "id ASC" }}

  #Validations
  validates_presence_of :name, :date, :min_rank, :max_rank
  validates_date :date
  validates_numericality_of :min_rank, :only_integer => true, :greater_than => 0, :less_than => 16, :allow_nil => false
  validates_numericality_of :max_rank, :only_integer => true, :greater_than_or_equal_to => :min_rank, :less_than => 16, :allow_nil => true
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"

  #Callbacks
  before_destroy :check_if_destroyable

  def check_if_destroyable
    if self.sections.active.empty?
      return true
    else
      end_tournament_now
      return false
    end
  end

  def end_tournament_now
    self.sections.active.each{ |s| s.destroy }
    self.active = false
    self.save!
  end

end
