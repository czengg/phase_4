require 'test_helper'

class DojoStudentTest < ActiveSupport::TestCase
  
  #Relationship macros
  should belong_to(:dojo)
  should belong_to(:student)

  #Validation macros
  should validate_presence_of(:dojo_id)
  should validate_presence_of(:student_id)
  should validate_presence_of(:start_date)

  #Validating start_date
  should allow_value(4.years.ago).for(:start_date)
  should allow_value(1.day.ago).for(:start_date)
  should allow_value(Time.now.to_date).for(:start_date)
  should_not allow_value(Time.now.next_month.to_date).for(:start_date)
  should_not allow_value(Time.now.next_year.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)

  #Validating end_date
  should allow_value(4.years.ago).for(:start_date)
  should allow_value(1.day.ago).for(:start_date)
  should allow_value(Time.now.to_date).for(:start_date)
  should_not allow_value(Time.now.next_month.to_date).for(:start_date)
  should_not allow_value(Time.now.next_year.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)

  #Testing with context
  context "Creating three dojo_students" do
  	
  	#create objects
  	setup do
  		@ed = FactoryGirl.create(:student)
  		@fred = FactoryGirl.create(:student, :first_name => "Fred", :rank => 5, :waiver_signed => false, :date_of_birth => 5.years.ago.to_date, :phone => "1234567890", :active => true)
  		@shadyside = FactoryGirl.create(:dojo)
  		@squirrelhill = FactoryGirl.create(:dojo, :name => "Squirrel Hill", :street => "1324 Murray Ave", :zip => "15444", :active => false)
  		@rec1 = FactoryGirl.create(:dojo_student, :student => @ed, :dojo => @shadyside)
  		@rec2 = FactoryGirl.create(:dojo_student, :student => @fred, :dojo => @squirrelhill, :start_date => Date.today)
  		@rec3 = FactoryGirl.create(:dojo_student, :student => @ed, :dojo => @squirrelhill, :start_date => 2.years.ago.to_date, :end_date => 1.day.ago.to_date)
  	end

  	teardown do
  		@ed.destroy
  		@fred.destroy
  		@shadyside.destroy
  		@squirrelhill.destroy
  		@rec1.destroy
  		@rec2.destroy
  		@rec3.destroy
  	end

  	should "show that student, dojo, dojo_student is created properly" do
  		puts "Start"
  		assert_equal "Ed", @ed.first_name
  		puts "Ed done"
  		assert_equal "Shadyside", @shadyside.name
  		puts "Shadyside done"
  		assert_equal "Fred", @rec2.student.name
  		puts "Fred done"
  	end



  	# should "have all the "

  end

end
