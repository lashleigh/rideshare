class Trip
  include MongoMapper::Document

  key :name, String
  key :route, Array
  key :has_car, Boolean, :default => true
  key :will_drive, Boolean, :default => true
  key :num_stops, Integer, :default => 2

  many :places, :in => :routes
  timestamps!

  def add_place(place_id)
    coll = MongoMapper.database.collection("trips")
    coll.update({'_id' => id, 'route' => {'$ne' => place_id}}, 
                {'$inc' => {'num_stops' => 1}, '$push' => {'route' => place_id}})
    Place.find(place_id).add_trip(id)
  end

  def remove_place(place_id)
    coll = MongoMapper.database.collection("trips")
    coll.update({'_id' => id, 'route' => place_id}, 
                {'$inc' => {'num_stops' => -1}, '$pull' => {'route' => place_id}})
    Place.find(place_id).remove_trip(id)
  end
end
