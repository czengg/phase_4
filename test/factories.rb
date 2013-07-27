FactoryGirl.define do
  factory :student do
    first_name "Ed"
    last_name "Gruberman"
    rank 1
    waiver_signed true
    date_of_birth 9.years.ago.to_date
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active true
  end
  
  factory :event do
    name "Sparring"
    active true
  end
  
  factory :section do
    association :tournament
    association :event
    min_age 9
    max_age 10
    min_rank 1
    max_rank 2
    round_time 1.hour.ago.to_time
    active true
  end
  
  factory :registration do
    association :section
    association :student
    final_standing 14
    fee_paid true
    date Date.today
  end

  factory :dojo do
    name "Shadyside"
    street "5000 Forbes Ave"
    zip "15213"
    active true
  end

  factory :dojo_student do
    association :student
    association :dojo
    start_date Date.today
  end

  factory :tournament do
    name "A&M Tournament"
    date Time.now.next_week.to_date
    min_rank 1
    max_rank 10
    active true
  end

end
