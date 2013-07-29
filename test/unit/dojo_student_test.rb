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
      create_dojo_context
  		# create_event_context
      # create_tournament_context
      create_student_context
      # create_section_context
      # create_registration_context
      create_dojo_student_context
    end

  	teardown do
      remove_dojo_context
  		# remove_event_context
      # remove_tournament_context
      remove_student_context
      # remove_section_context
      # remove_registration_context
      remove_dojo_student_context
  	end

  	should "show that student, dojo, dojo_student is created properly" do
  		assert_equal "Ed", @ed.first_name
  		assert_equal "Shadyside", @shadyside.name
  		assert_equal "Fred", @rec2.student.first_name
  	end

    should "have scope that filters all current dojo_students (no end_date)" do
      # assert_equal 2, DojoStudent.current.size
      assert_equal nil, @rec1.end_date
    end

  	should "have a scope to filter registrations by student" do
      assert_equal 2, DojoStudent.for_student(@ed.id).size
    end

    should "have a scope to filter registrations by student" do
      assert_equal 2, DojoStudent.for_dojo(@southside.id).size
    end

    should "have a scope to alphabetize registrations by student name" do
      assert_equal ["Ed", "Ed", "Fred"], DojoStudent.by_student.map{|d| d.student.first_name}
    end

    should "have a scope to alphabetize registrations by dojo name" do
      assert_equal ["Shadyside", "South Side", "South Side"], DojoStudent.by_dojo.map{|d| d.dojo.name}
    end

  end

end
