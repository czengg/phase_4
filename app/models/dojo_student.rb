class DojoStudent < ActiveRecord::Base
  attr_accessible :dojo_id, :end_date, :start_date, :student_id

  #Relationships
  belongs_to :dojo
  belongs_to :student

  #Scopes
  scope :current, where('end_date = ?', nil)
  scope :for_student, lambda { |student_id| where('student_id = ?', student_id)}
  scope :for_dojo, lambda { |dojo_id| where('dojo_id = ?', dojo_id)}
  scope :by_student, joins(:student).order('students.last_name, students.first_name')
  scope :by_dojo, joins(:dojo).order('dojos.name')

  #Validations
  validates_presence_of :dojo_id, :student_id, :start_date
  validates_date :start_date, :on_or_before => lambda { Date.today }, :on_or_before_message => "must be a date before today"
  validates_date :end_date,  :on_or_before => lambda { Date.today }, :on_or_before_message => "must be a date before today", :allow_nil => true, :allow_blank => true
  validate :dojo_is_active_in_system
  validate :student_is_active_in_system

  #Callbacks
  # before_save end_previous_assignment

  def end_previous_assignment
  	all_student_dojos = DojoStudent.for_student.current.all.map{ |d| d.id }
  	all_student_dojos.each { |dojo_rec| end_assignment_now(dojo_rec)}
  end

  def end_assignment_now(dojo_rec)
  	dojo_rec.end_date = Date.today
  	dojo_rec.save!
  end

  private
  def dojo_is_active_in_system
  	all_active_dojos = Dojo.active.all.map{ |d| d.id }
  	unless all_active_dojos.include?(self.dojo_id)
  		errors.add(:dojo_id, "is not an active dojo in the system")
  	end
  end

  def student_is_active_in_system
  	all_active_students = Student.active.all.map{ |s| s.id }
  	unless all_active_students.include?(self.student_id)
  		errors.add(:student_id, "is not an active student in the system")
  	end
  end

end
