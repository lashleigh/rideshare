class TripOptions
  include MongoMapper::EmbeddedDocument

  key :shared_driving, Integer
  key :max_passengers, Integer
  key :max_luggage, Integer
  key :car_type, Integer

  belongs_to :trip

  def options_vals
    self.keys.select{|k, v| !self[k].nil? and k != "_id"}.map{|k,v| {k => self[k]}}
  end

end
