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
  timestamps!

  scope :by_duration_in_hours, lambda {|low, high| where(:duration.gte => low*3600,  :duration.lte => high*3600) }
  scope :by_distance_in_miles, lambda {|low, high| where(:distance.gte => low*1609.344, :distance.lte => high*1609.344) }

  scope :by_start, lambda {|start| where(:origin => start) }
  scope :by_finish, lambda {|finish| where(:destination => finish)}
  scope :near_coords, lambda {|coords| where(:id => {'$in' => Trip.near(coords)}) } 

  def self.intersect(coords_array, options = {})
    res = Trip.near(coords_array[0], options)

    if coords_array[1]
      (1..coords_array.length-1).each do |i|
        res = res & Trip.near(coords_array[i], options)
      end
    end
    return res
  end

  def self.near(coords, options = {})
    options[:radius] ||= 60
    options[:trips] ||=Trip.all

    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end
    puts coords

    trips = {}
    options[:trips].each do |trip|
      dist = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords)}.min
      trips[trip.id] = dist
    end
    return trips.select {|k, v| v < options[:radius]}.keys
  end

  def self.find_match(start, finish, options = {})
    options[:limit] ||= 20

    case start
      when Array; start
      when String; start = Geocoder.coordinates(start)
    end
    case finish
      when Array; finish
      when String; finish = Geocoder.coordinates(finish)
    end
    dist  = Geocoder::Calculations::distance_between(start, finish)
    options[:radius] ||= dist*0.1

    nearest_match = []
    Trip.all.each do |trip|
      dist_start  = trip.route.map{|point| Geocoder::Calculations::distance_between(point, start)}.min
      dist_finish = trip.route.map{|point| Geocoder::Calculations::distance_between(point, finish)}.min
      nearest_match.push({"trip" => trip.id, "dist_start" => dist_start, "dist_finish" => dist_finish})
    end
    res = {}
    res["perfect"]     = nearest_match.select {|k| k["dist_start"] < options[:radius] and k["dist_finish"] < options[:radius]} 
    res["start_only"]  = nearest_match.select {|k| k["dist_start"] < options[:radius] and k["dist_finish"] > options[:radius]} 
    res["finish_only"] = nearest_match.select {|k| k["dist_start"] > options[:radius] and k["dist_finish"] < options[:radius]} 
    return res 
  end

  def self.nearest(coords, options={})
    options[:limit] ||= 20
    options[:trips] ||= Trip.all

    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end

    nearest_trips = []
    options[:trips].each do |trip|
      dist = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords)}.min
      nearest_trips.push({"trip" => trip.id, "dist" => dist})
    end
    return nearest_trips.sort_by{|a| a["dist"]}.first(options[:limit]).map{|k| Trip.find(k["trip"])}
  end

  def self.nearest_with_index(coords, options = {})
    options[:radius] ||= 65

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
    duration + (duration/86400)*n*3600
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
