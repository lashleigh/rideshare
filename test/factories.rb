# This will guess the User class
FactoryGirl.define do
  factory :trip do
    origin      'Seattle, WA'
    destination 'San Diego, CA'
    distance    '3098218.0'
    duration    '112080.0'
    route        "[[0,0],[1,1],[2,2]]"
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
  factory :search do
    origin             'Seattle, WA'
    destination        'San Diego, CA'
    origin_radius       25
    destination_radius  25

    factory :search_with_coords do
      origin_coords    [45,-75]
      destination_coords  [44,-122]
    end
  end
end
