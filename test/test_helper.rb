require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Prof. H's deny method to improve readability of tests
  def deny(condition, msg="")
    # a simple transformation to increase readability IMO
    assert !condition, msg
  end
  
  # Context for events
  def create_event_context
    @sparring = FactoryGirl.create(:event)
    @breaking = FactoryGirl.create(:event, :name => "Breaking")
    @weapons = FactoryGirl.create(:event, :name => "Weapons", :active => false)
  end
  
  def remove_event_context
    Event.delete_all
  end
  
  # Context for students
  def create_student_context
    @ed = FactoryGirl.create(:student)
    @ted = FactoryGirl.create(:student, :first_name => "Ted", :phone => "412-268-2323")
    @fred = FactoryGirl.create(:student, :first_name => "Fred", :last_name => "Smith", :rank => 9)
    @ned = FactoryGirl.create(:student, :first_name => "Ned", :date_of_birth => 13.years.ago.to_date)
    @noah = FactoryGirl.create(:student, :first_name => "Noah", :last_name => "Major", :rank => 9, :date_of_birth => 13.years.ago.to_date)
    @howard = FactoryGirl.create(:student, :first_name => "Howard", :last_name => "Minor", :rank => 8, :date_of_birth => 169.months.ago.to_date)
    @jen = FactoryGirl.create(:student, :first_name => "Jen", :last_name => "Hanson", :rank => 12, :date_of_birth => 167.months.ago.to_date)
    @julie = FactoryGirl.create(:student, :first_name => "Julie", :last_name => "Henderson", :rank => 11, :date_of_birth => 1039.weeks.ago.to_date, :waiver_signed => false)
    @jason = FactoryGirl.create(:student, :first_name => "Jason", :last_name => "Hoover", :rank => 14, :active => false, :date_of_birth => 36.years.ago.to_date)
  end
  
  def remove_student_context
    Student.delete_all
  end
  
  # Context for sections (requires events and tournaments)
  def create_section_context
    @wy_belt_sparring = FactoryGirl.create(:section, :event => @sparring, :tournament => @am)
    @wy_belt_breaking = FactoryGirl.create(:section, :event => @breaking, :tournament => @pm)
    @r_belt_breaking = FactoryGirl.create(:section, :event => @breaking, :tournament => @pm, :min_rank => 8, :max_rank => 10, :min_age => 13, :max_age => 15)
    @r_belt_sparring = FactoryGirl.create(:section, :event => @sparring, :tournament => @am, :min_rank => 8, :max_rank => 10, :min_age => 13, :max_age => 15, :active => false)
    @bl_belt_breaking = FactoryGirl.create(:section, :event => @breaking, :tournament => @pm, :min_rank => 11, :max_rank => nil, :min_age => 18, :max_age => nil)
  end
  
  def remove_section_context
    Section.delete_all
  end
  
  # Context for registrations (requires sections, students)
  def create_registration_context
    @reg_ed_sp = FactoryGirl.create(:registration, :student => @ed, :section => @wy_belt_sparring)
    @reg_ted_sp = FactoryGirl.create(:registration, :student => @ted, :section => @wy_belt_sparring, :fee_paid => false, :final_standing => 12)
    @reg_ted_br = FactoryGirl.create(:registration, :student => @ted, :section => @wy_belt_breaking, :final_standing => 10)
    @reg_hm_br = FactoryGirl.create(:registration, :student => @howard, :section => @r_belt_breaking, :date => 1.day.ago.to_date, :fee_paid => false, :final_standing => 9)
    @reg_nm_br = FactoryGirl.create(:registration, :student => @noah, :section => @r_belt_breaking, :date => 2.days.ago.to_date, :final_standing => 3)
  end
  
  def remove_registration_context
    Registration.delete_all
  end

  def create_dojo_context
    @shadyside = FactoryGirl.create(:dojo)
    sleep 1
    @squirrelhill = FactoryGirl.create(:dojo, :name => "Squirrel Hill", :street => "1324 Murray Ave", :zip => "15444", :active => false, :state => "CA")
    sleep 1
    @southside = FactoryGirl.create(:dojo, :name => "South Side", :street => "1234 Carson St", :zip => "15222", :active => true, :state => "CO")
  end

  def remove_dojo_context
    Dojo.delete_all
  end

  def create_tournament_context
    @am = FactoryGirl.create(:tournament)
    @pm = FactoryGirl.create(:tournament, :name => "P&M Tournament", :date => Time.now.next_month.to_date, :min_rank => 5, :max_rank => 15)
    @cm = FactoryGirl.create(:tournament, :name => "C&M Tournament", :date => 2.days.ago.to_date, :min_rank => 7, :max_rank => 10, :active => false)
  end

  def remove_tournament_context
    Tournament.delete_all
  end

  def create_dojo_student_context
    @rec1 = FactoryGirl.create(:dojo_student, :student => @ed, :dojo => @shadyside)
    @rec2 = FactoryGirl.create(:dojo_student, :student => @fred, :dojo => @southside, :start_date => Date.today)
    @rec3 = FactoryGirl.create(:dojo_student, :student => @ed, :dojo => @southside, :start_date => 2.years.ago.to_date, :end_date => 1.day.ago.to_date)
  end

  def remove_dojo_student_context
    DojoStudent.delete_all
  end

end