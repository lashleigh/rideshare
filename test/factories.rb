# This will guess the User class
FactoryGirl.define do
  factory :authorization do
    provider 'twitter'
    uid '16555958'
  end

  factory :user do
    name 'ashleigh'
  end

  factory :trip do
    origin      'Seattle, WA'
    destination 'San Diego, CA'
    distance    '3098218.0'
    duration    '112080.0'
    route        [[0,0],[1,1],[2,2]]
    encoded_poly "poly"
    start_flexibility "exact"

    factory :past_trip do
      start_date 7.days.ago
    end

    factory :future_trip do
      start_date 7.days.since
    end
  end
  factory :trip_options do
    cost          '20.0' 
    shared_driving nil
    max_passengers nil
    max_luggage    nil
    car_type       nil
    smoke_breaks   nil
  end
end
