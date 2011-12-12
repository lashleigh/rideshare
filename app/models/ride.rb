class Ride
  include MongoMapper::Document

  key :origin, String
  key :destination, String
  key :summary, String, :default => ''
  key :url, String
  
  key :start_date, Time
  key :start_time, String, :in => ["any", "e", "m", "a", "l"], :default => "any"
  key :start_flexibility, String, :in => ["exact", "onebefore", "oneafter", "one", "two", "three"], :default => "one"
  
  key :tags, Array
  key :views, Integer, :default => 0
  
  scope :future, where(:start_date.gte => Time.now) 

end
