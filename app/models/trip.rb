class Trip
  include MongoMapper::Document

  key :title, String
  key :route, Array, :typecast => 'Array'
  key :origin, String
  key :start_date, Date
  key :destination, String
  key :end_date, Date
  key :tags, Array
  key :google_options, Hash, :default => {"avoid_highways" => false, "avoid_tolls" => false, "waypoints" => []} 
  key :has_car, Boolean, :default => true
  key :will_drive, Boolean, :default => true

  #many :routes, :in => :route_ids
  #ensure_index [[[:route],'2d']]
  timestamps!

  def self.find_match(start, finish, options = {})
    options[:limit] ||= 20
    dist  = Geocoder::Calculations::distance_between(start, finish)
    options[:radius] ||= dist*0.1

    geo_o = Geocoder.search(start)
    geo_d = Geocoder.search(finish)
    origin      = [geo_o[0].latitude, geo_o[0].longitude]
    destination = [geo_d[0].latitude, geo_d[0].longitude]
    nearest_match = []
    Trip.all.each do |trip|
      dist_origin = trip.route.map{|point| Geocoder::Calculations::distance_between(point, origin)}.min
      dist_destination = trip.route.map{|point| Geocoder::Calculations::distance_between(point, destination)}.min
      res_hash = {"trip" => trip.origin+" "+trip.destination, "dist_origin" => dist_origin, "dist_destination" => dist_destination}
      res_hash["type"] = []
      if dist_origin <= dist 
        res_hash["type"].push("origin")
      end
      if dist_destination <= dist
        res_hash["type"].push("destination")
      end
      nearest_match.push(res_hash)
    end
    return nearest_match.sort_by{|a| a["dist_origin"]}.first(options[:limit])
  end

  def self.nearest(coords, options={})
    options[:limit] ||= 20

    nearest_trips = []
    Trip.all.each do |trip|
      dist = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords)}.min
      nearest_trips.push({"trip" => trip.id, "dist" => dist})
    end
    return nearest_trips.sort_by{|a| a["dist"]}.first(options[:limit])
  end

  def self.nearest_with_index(coords)
    all_trips_distance = []
    Trip.all.each do |trip|
      i = 0
      trip.route.each do |point|
        dist = Geocoder::Calculations::distance_between(point, coords)
        all_trips_distance.push({"trip" => trip.id, "dist" => dist, "index" => i})
        i+=1
      end
    end
    return all_trips_distance.sort_by{|obj| obj["dist"]}.first(20)
  end

  def self.find_all_within_bounds(bounds) 
    where(:route => {'$within' => {'$box' => bounds}}).all
  end
 
  def custom_update(params)
    Trip.set({:id => id.as_json},
              :title => params[:title],
              :origin => params[:origin],
              :destination => params[:destination],
              :route => params[:route],
              :tags => params[:tags],
              :will_drive => params[:will_drive],
              :has_car => params[:has_car]
            )
  end
  
end
