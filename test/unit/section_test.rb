require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # Shoulda macros
  should belong_to(:event)
  should have_many(:registrations)
  should have_many(:students).through(:registrations)
  should belong_to(:tournament)
  
  # tests for min_age
  should validate_numericality_of(:min_age)
  should allow_value(7).for(:min_age)
  should allow_value(29).for(:min_age)
  should allow_value(42).for(:min_age)
  should_not allow_value(0).for(:min_age)
  should_not allow_value(4).for(:min_age)
  should_not allow_value(-1).for(:min_age)
  should_not allow_value(3.14159).for(:min_age)
  should_not allow_value(nil).for(:min_age)
  
  # limited tests for max_age
  should validate_numericality_of(:max_age)
  should allow_value(nil).for(:max_age)
  
  # tests for event_id
  should allow_value(2).for(:event_id)
  should allow_value(10).for(:event_id)
  should allow_value(42).for(:event_id)
  should_not allow_value(0).for(:event_id)
  should_not allow_value(-1).for(:event_id)
  should_not allow_value(3.14159).for(:event_id)
  should_not allow_value(nil).for(:event_id)
  
  # tests for tournament_id
  should allow_value(2).for(:tournament_id)
  should allow_value(10).for(:tournament_id)
  should allow_value(42).for(:tournament_id)
  should_not allow_value(0).for(:tournament_id)
  should_not allow_value(-1).for(:tournament_id)
  should_not allow_value(3.14159).for(:tournament_id)
  should_not allow_value(nil).for(:tournament_id)

  # test active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
  
  # Context for rest of testing
  context "Creating context for sections" do
    setup do
      create_event_context
      create_tournament_context
      create_section_context
    end
    
    teardown do
      remove_event_context
      remove_tournament_context
      remove_section_context
    end
    
    should "have working factories" do
      assert_equal 1, @wy_belt_sparring.min_rank
      assert_equal 2, @wy_belt_breaking.max_rank
      assert_equal 13, @r_belt_breaking.min_age
      assert_equal 15, @r_belt_sparring.max_age
    end
    
    should "does not allow sections for events not in the system" do
      @blocks = FactoryGirl.build(:event, :name => "Breaking Blocks")
      @bad_section = FactoryGirl.build(:section, :event => @blocks, :tournament => @am)  # @blocks is not in the database yet...
      deny @bad_section.valid?
    end

    should "does not allow sections for tournaments not in the system" do
      @dm = FactoryGirl.build(:tournament, :name => "D&M Tournament", :date => Time.now.next_month.to_date, :min_rank => 5, :max_rank => 15)
      @bad_section = FactoryGirl.create(:section, :event => @sparring, :tournament => @dm)
      deny @bad_section.valid?
    end
    
    should "does not allow sections for inactive events" do
      @bad_section = FactoryGirl.build(:section, :event => @weapons, :tournament => @am)  # white belts with weapons could be bad indeed...
      deny @bad_section.valid?
    end
    
    should "has max ages greater than or equal to min ages" do
      @bad_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @am, :min_age => 10, :max_age => 9)
      deny @bad_section.valid?
      @ok_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @am, :min_age => 10, :max_age => 10)
      assert @ok_section.valid?
    end
    
    should "has max ages that are only integers" do
      @bad_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @pm, :min_age => 10, :max_age => 12.5)
      deny @bad_section.valid?
    end
    
    should "has max ranks greater than or equal to min ranks" do
      @bad_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @pm, :min_rank => 10, :max_rank => 9)
      deny @bad_section.valid?
      @ok_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @pm, :min_rank => 10, :max_rank => 10)
      assert @ok_section.valid?
    end
    
    should "has max ranks that are only integers" do
      @bad_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @pm, :min_rank => 11, :max_rank => 12.5)
      deny @bad_section.valid?
    end
    
    should "not allow duplicate sections to be created" do
      @duplicate_section = FactoryGirl.build(:section, :event => @breaking, :tournament => @pm, :min_rank => 8, :max_rank => 10, :min_age => 13, :max_age => 15)
      deny @duplicate_section.valid?
    end
    
    should "allow an existing section to be edited" do
      @wy_belt_sparring.active = false
      assert @wy_belt_sparring.valid?
    end
        
    should "have a scope to alphabetize sections by event name" do
      assert_equal ["Breaking", "Breaking", "Breaking", "Sparring", "Sparring"], Section.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to show only active sections" do
      assert_equal ["Breaking", "Breaking", "Breaking", "Sparring"], Section.active.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to show only inactive sections" do
      assert_equal ["Sparring"], Section.inactive.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to show all sections for a particular age (allow nil max_age)" do
      assert_equal ["Breaking:13-15", "Sparring:13-15"], Section.for_age(14).alphabetical.map{|s| "#{s.event.name}:#{s.min_age}-#{s.max_age}"}
      assert_equal ["Breaking:18-"], Section.for_age(19).alphabetical.map{|s| "#{s.event.name}:#{s.min_age}-#{s.max_age}"}
    end
    
    should "have a scope to show all sections for a particular rank (allow nil max_rank)" do
      assert_equal ["Breaking:1-2", "Sparring:1-2"], Section.for_rank(2).alphabetical.map{|s| "#{s.event.name}:#{s.min_rank}-#{s.max_rank}"}
      assert_equal ["Breaking:11-"], Section.for_rank(11).alphabetical.map{|s| "#{s.event.name}:#{s.min_rank}-#{s.max_rank}"}
    end
    
    should "have a scope to show all sections for a particular event" do
      assert_equal ["rank:1 - age:9", "rank:8 - age:13", "rank:11 - age:18"], Section.for_event(@breaking.id).alphabetical.map{|s| "rank:#{s.min_rank} - age:#{s.min_age}"}
      assert_equal ["rank:1 - age:9", "rank:8 - age:13"], Section.for_event(@sparring.id).alphabetical.map{|s| "rank:#{s.min_rank} - age:#{s.min_age}"}
    end

    should "have a scope to show all sections for a particular tournament" do
      assert_equal ["Sparring", "Sparring"], Section.for_tournament(@am.id).map{|s| s.event.name}
    end

    should "make sure a section with registrations isn't deleted" do
      @ed = FactoryGirl.create(:student)
      @reg_ed_sp = FactoryGirl.create(:registration, :student => @ed, :section => @wy_belt_sparring)      
      assert_equal false, @wy_belt_sparring.check_if_destroyable
    end

    should "make sure a section with no registrations is deleted" do
      assert_equal true, @wy_belt_sparring.check_if_destroyable
    end
  end
end
