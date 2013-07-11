class User < ActiveRecord::Base
  attr_accessible :active, :email, :password_digest, :role, :student_id
end
