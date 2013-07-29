require 'test_helper'

class UserTest < ActiveSupport::TestCase
  

  def new_user(attributes = {})
  	@ed = FactoryGirl.create(:student)
    attributes[:email] ||= 'foo@example.com'
    attributes[:student_id] ||= @ed.id
    attributes[:password_digest] ||= 'abc123'
    user = User.new(attributes)
    user.valid? # run validations
    user
  end

  def setup
    User.delete_all
  end

  def test_valid
    assert new_user.valid?
  end

  def test_require_student_id
    assert_equal ["can't be blank"], new_user(:student_id => '').errors[:student_id]
  end

  def test_require_password
    assert_equal ["can't be blank"], new_user(:password_digest => '').errors[:password_digest]
  end

  def test_require_well_formed_email
    assert_equal ["is invalid"], new_user(:email => 'foo@bar@example.com').errors[:email]
  end

  def test_validate_uniqueness_of_email
    new_user(:email => 'bar@example.com').save!
    assert_equal ["has already been taken"], new_user(:email => 'bar@example.com').errors[:email]
  end

  def test_validate_password_length
    assert_equal ["is too short (minimum is 4 characters)"], new_user(:password_digest => 'bad').errors[:password_digest]
  end

  def test_generate_password_hash_and_salt_on_create
  	User.delete_all
    user = new_user
    user.save!
    assert user.password_hash
    assert user.password_salt
  end

  def test_authenticate_by_email
    User.delete_all
    user = new_user(:email => 'foo2@bar.com', :password_digest => 'secret')
    user.save!
    assert_equal user, User.authenticate('foo2@bar.com', 'secret')
  end

  def test_authenticate_bad_email
    assert_nil User.authenticate('nonexisting', 'secret')
  end

  def test_authenticate_bad_password
    User.delete_all
    new_user(:email => 'foo1@bar.com', :password_digest => 'secret').save!
    assert_nil User.authenticate('foo1@bar.com', 'badpassword')
  end

end
