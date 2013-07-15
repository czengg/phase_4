class User < ActiveRecord::Base
  attr_accessible :active, :email, :password_digest, :role, :student_id

  #Relationships
  has_one :student

  #Scopes

  #Validations
  validates_presence_of :student_id, :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password_digest, :on => :create
  validates_confirmation_of :password_digest
  validates_length_of :password_digest, :minimum => 4, :allow_blank => true
  validate :student_is_active_in_system
  validate :email_is_in_system

  #Callbacks
  before_save :prepare_password

  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private
  def student_is_active_in_system
  	all_active_students = Student.active.all.map{ |s| s.id }
  	unless all_active_students.include?(self.student_id)
  		errors.add(:student_id, "is not an active student in the system")
  	end
  end

  def email_is_in_system
  	all_emails = User.all.map{ |u| u.email }
  	unless all_emails.include?(self.email) == true
  		errors.add(:email, "is already in system")
  	end	
  end 

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
