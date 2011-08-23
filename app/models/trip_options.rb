class TripOptions
  include MongoMapper::EmbeddedDocument

  key :shared_driving, Integer
  key :max_passengers, Integer
  key :max_luggage, Integer
  key :car_type, Integer

  belongs_to :trip
end
