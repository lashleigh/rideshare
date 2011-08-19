class Place
  include MongoMapper::Document
  #include Geocoder::Model::MongoMapper
  #geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates

  key :address, String
  key :coords, Array
  Place.ensure_index(:coords) #[["coords", Mongo::GEO2D]])

  key :active_rides, Array
  key :num_rides, Integer, :default => 0

  many :trips, :in => :active_rides

  def trips_distribution
    result = Hash.new
    result["starting"] = []
    result["ending"] = []
    result["containing"] = []
    active_rides.each do |trip|
      t = Trip.find_by_id(trip)
      if t.route[0] == id.as_json
        result["starting"].push(t)
      elsif t.route.last == id.as_json
        result["ending"].push(t)
      else
        result["containing"].push(t)
      end
    end
    return result
  end

  def ending_in 
    trips = []
    active_rides.each do |trip|
      t = Trip.find_by_id(trip)
      if t.route.last == id.as_json
        trips.push(t)
      end
    end
    return trips
  end
  def starting_from
    trips = []
    active_rides.each do |trip|
      t = Trip.find_by_id(trip)
      if t.route.first == id.as_json
        trips.push(t)
      end
    end
    return trips
  end
  def nearby 
    coll = MongoMapper.database.collection("places")
    coll.find({"coords" => {"$near" => coords}}, {:limit => 4}).as_json
  end

  def add_trip(trip_id)
    coll = MongoMapper.database.collection("places")
    coll.update({'_id' => id, 'active_rides' => {'$ne' => trip_id}}, 
                {'$inc' => {'num_rides' => 1}, '$push' => {'active_rides' => trip_id}})
  end

  def remove_trip(trip_id)
    coll = MongoMapper.database.collection("places")
    coll.update({'_id' => id, 'active_rides' => trip_id}, 
                {'$inc' => {'num_rides' => -1}, '$pull' => {'active_rides' => trip_id}})
  end

end

