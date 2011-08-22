class Trip
  include MongoMapper::Document

  key :origin, String, :required => true
  key :start_date, Time, :required => true
  key :start_time, String, :in => (1..23).to_a.push("a", "r", "m", "n", "e", "l")
  key :start_flexibility, Array
  key :destination, String, :required => true
  key :distance, Float #in meters
  key :duration, Float #in hours
  
  key :tags, Array

  key :route, Array, :typecast => 'Array'
  key :encoded_poly, String
  key :has_car, Boolean, :default => true
  key :will_drive, Boolean, :default => true

  one :google_options
  # many :routes
  # validates_presence_of :origin, :destination
  # ensure_index [[[:route],'2d']]
  timestamps!

  def self.find_match(start, finish, options = {})
    options[:limit] ||= 20

    coords_start  = [ start.latitude, start.longitude]
    coords_finish = [finish.latitude, finish.longitude]
    dist  = Geocoder::Calculations::distance_between(coords_start, coords_finish)
    options[:radius] ||= dist*0.1

    nearest_match = []
    Trip.all.each do |trip|
      dist_start  = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords_start)}.min
      dist_finish = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords_finish)}.min
      nearest_match.push({"trip" => trip.id, "dist_start" => dist_start, "dist_finish" => dist_finish})
    end
    res = {}
    res["perfect"]     = nearest_match.select {|k| k["dist_start"] < options[:radius] and k["dist_finish"] < options[:radius]} 
    res["start_only"]  = nearest_match.select {|k| k["dist_start"] < options[:radius] and k["dist_finish"] > options[:radius]} 
    res["finish_only"] = nearest_match.select {|k| k["dist_start"] > options[:radius] and k["dist_finish"] < options[:radius]} 
    return res 
  end

  def self.nearest(some_geo, options={})
    options[:limit] ||= 20
    coords = [some_geo.latitude, some_geo.longitude]

    nearest_trips = []
    Trip.all.each do |trip|
      dist = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords)}.min
      nearest_trips.push({"trip" => trip.id, "dist" => dist})
    end
    return nearest_trips.sort_by{|a| a["dist"]}.first(options[:limit])
  end

  def self.nearest_with_index(coords, options = {})
    options[:radius] ||= 25

    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
      else coords = [coords.latitude, coords.longitude]
    end

    hash_trips = {}
    Trip.all.each do |trip|
      last_index = trip.route.length
      min ||= options[:radius]

      trip.route.each_with_index do |point, i|
        dist = Geocoder::Calculations::distance_between(point, coords)
        if dist < min
          min = dist
          hash_trips[trip.id] = {"min" => min, "index" => i, "last_index" => i+1==last_index}
        end
      end
    end
    res = {}
    res["end"]     = hash_trips.select {|k, v| v["last_index"] == true} 
    res["start"]   = hash_trips.select {|k, v| v["index"] == 0 } 
    res["through"] = hash_trips.select {|k, v| v["index"] != 0 and v["last_index"] == false } 
    return res
  end

  def distance_between_points
    zipped = route.slice(1..-1).zip(route)
    distances = zipped.map {|point1, point2| Geocoder::Calculations::distance_between(point1, point2) }
    avg = distances.sum / distances.length
    max = distances.max
    min = distances.min
    return {"avg" => avg, "max" => max, "min" => min}
  end

  def with_sleep(n)
    if duration > 72000 #60*60*20
      d = duration + (duration/86400)*n*3600
      d
    else
      nil
    end
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
