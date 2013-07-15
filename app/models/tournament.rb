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
  scope :next, lambda { |offset| { :conditions => ['id > ?', :id], :limit => 1, :offset => offset, :order => "id DESC" }}

  #Validations
  validates_presence_of :name, :date, :min_rank, :max_rank
  validates_date :date
  validates_numericality_of :min_rank, :only_integer => true, :greater_than_or_equal_to => 1, :less_than => 16, :allow_nil => false
  validates_numericality_of :max_rank, :only_integer => true, :greater_than_or_equal_to => :min_rank, :less_than => 16
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"

  #Callbacks
  # before_destroy :check_if_destroyable

  def check_if_destroyable
    all_sections = Section.all.map{|s| s}
    all_sections.each do |sec|
      if sec.tournament_id == self.id
        self.active = false
        self.save!
        return true
      end
    end
    self.destroy
    self.save!
    return false
  end

end
