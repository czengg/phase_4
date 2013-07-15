require 'test_helper'

class DojoTest < ActiveSupport::TestCase
  
  #Relationship macros
  should have_many(:dojo_students)

  #Validation macros
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:zip)

  #Validating state
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should allow_value("OH").for(:state)
  should allow_value("CA").for(:state)
  should_not allow_value("bad").for(:state)
  should_not allow_value(10).for(:state)
  should_not allow_value(true).for(:state)

  #Validating zip
  should allow_value("03431").for(:zip)
  should allow_value("15217").for(:zip)
  should allow_value("15090").for(:zip)
  should_not allow_value("fred").for(:zip)
  should_not allow_value("3431").for(:zip)
  should_not allow_value("15213-9843").for(:zip)
  should_not allow_value("15d32").for(:zip)

  #Testing with context
  context "Creating three dojos" do

  	#create the dojos
  	setup do
  	  create_dojo_context
  	end

  	teardown do
  	  remove_dojo_context
  	end

  	#test one of factory
  	should "show that dojo is created properly" do
  		assert_equal "Shadyside", @shadyside.name
  	end

  	#test the scope 'alphabetical'
  	should "have all dojos are listed here in alphabetical order" do
  		assert_equal 3, Dojo.all.size
  		assert_equal ["Shadyside", "South Side", "Squirrel Hill"], Dojo.alphabetical.map{|d| d.name}
  	end

  	#test the scope 'active'
  	should "have all active dojos accounted for" do
  		assert_equal 2, Dojo.active.size
  	end

  	#test the scope 'inactive'
  	should "have all inactive dojos accounted for" do
  		assert_equal 1, Dojo.inactive.size
  	end

  	#test the scope 'by_state'
  	should "have all dojos listed here in alphabetical order of state" do
  		assert_equal 3, Dojo.all.size
  		assert_equal ["Shadyside", "Squirrel Hill", "South Side"], Dojo.by_state.map{|d| d.name}
  	end

  	#test custom validation 'dojo_name_is_already_in_system'
  	should "not allow dojo of same name to be created" do
  		@bad_dojo = FactoryGirl.build(:dojo, :name => "Squirrel Hill", :street => "1325 Murray Ave", :zip => "15344", :active => true, :state => "PA")
  		deny @bad_dojo.valid?
  	end
  end

end
