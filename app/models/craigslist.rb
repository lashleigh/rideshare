class Craigslist
  include MongoMapper::Document
  include Geocoder::Model::MongoMapper

  key :city, String
  key :state, String
  key :href, String
  key :approved, Boolean, :default => false
  key :coords, Array
  ensure_index [[ :coords, '2d']], :min => -180, :max => 180 

  def self.find_all_near_route(trip, options={})
    options[:radius] ||= 1500 #trip.distance_between_points["max"]*10
    nearest = trip.route.map{|trip_coords| Craigslist.nearby(trip_coords, options).all} 
    nearest.flatten.uniq
  end

  def self.nearby(coords, options = {})
    options[:radius] ||= 50
    Craigslist.where(:coords => {"$near" => coords, '$maxDistance' => options[:radius]/3959.0 })
  end

  def self.within(coords, radius, options={})
    options[:units] ||= "mi"
    Craigslist.where(:coords => {"$within" => {"$center" => [coords, radius/3959.0]}})
  end

  def nearby_trips
    trips = []
    Trip.all.each do |t|
      min = t.route.map{|trip_coord| Geocoder::Calculations::distance_between(coords, trip_coord) }.min
      if min < 50
        trips.push(t.id)
      end
    end
    trips
  end

  def temp
    #Craigslist.each do |l|; 
    #parts = l.split(" tab: "); c = Craigslist.new(:city =>parts[0], :state =>parts[1], :coords => Geocoder.coordinates(parts[0]+","+parts[1]), :href=>parts[2]); c.save; end
    #c = Craigslist.find_by_city(parts[0]); c.coords => Geocoder.coordinates(parts[0]+","+parts[1]); c.save
  end

end
