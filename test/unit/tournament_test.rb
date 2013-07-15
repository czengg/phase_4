require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  
  #Relationship macros
  should have_many(:sections)

  #Validation macros
  should validate_presence_of(:name)
  should validate_presence_of(:date)
  should validate_presence_of(:min_rank)
  should validate_presence_of(:max_rank)

  #Validating date
  should allow_value(Time.now.next_month.to_date).for(:date)
  should allow_value(Time.now.next_year.to_date).for(:date)
  should allow_value(Time.now.to_date).for(:date)
  should allow_value(4.years.ago).for(:date)
  should allow_value(1.day.ago).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)
  
  #Validating min_rank
  should validate_numericality_of(:min_rank)
  should allow_value(1).for(:min_rank)
  should allow_value(7).for(:min_rank)
  should allow_value(10).for(:min_rank)
  should allow_value(12).for(:min_rank)
  should_not allow_value(0).for(:min_rank)
  should_not allow_value(-1).for(:min_rank)
  should_not allow_value(3.14159).for(:min_rank)
  should_not allow_value(nil).for(:min_rank)

  #Validating max_rank
  should validate_numericality_of(:max_rank)
  should_not allow_value(nil).for(:max_rank)

  #Testing with context
  context "Creating three tournaments" do

  	setup do
  		create_tournament_context
  	end

  	teardown do
  		remove_tournament_context
  	end

  	should "have working factories" do
  		assert_equal "A&M Tournament", @am.name
  		assert_equal "P&M Tournament", @pm.name
  		assert_equal "C&M Tournament", @cm.name
  	end

  	should "have a scope to chronological tournaments by date" do
  		assert_equal ["C&M Tournament", "A&M Tournament", "P&M Tournament"], Tournament.chronological.map{|t| t.name}
  	end

  	should "have a scope to alphabetize tournaments by name" do
  		assert_equal ["A&M Tournament", "C&M Tournament", "P&M Tournament"], Tournament.alphabetical.map{|t| t.name}
  	end

  	should "have all active tournaments accounted for" do
  		assert_equal ["A&M Tournament", "P&M Tournament"], Tournament.active.alphabetical.map{|t| t.name}
  	end

  	should "have all inactive tournaments accounted for" do
  		assert_equal ["C&M Tournament"], Tournament.inactive.alphabetical.map{|t| t.name}
  	end

  	should "have all past tournaments accounted for" do
  		assert_equal ["C&M Tournament"], Tournament.past.alphabetical.map{|t| t.name}
  	end

  	should "have all upcoming tournaments accounted for" do
  		assert_equal ["A&M Tournament", "P&M Tournament"], Tournament.upcoming.alphabetical.map{|t| t.name}
  	end

  	should "have a scope that outputs the next nth tournaments" do
  		assert_equal ["A&M Tournament", "P&M Tournament"], Tournament.next(1).map{|t| t.name}
  	end

  end

end
