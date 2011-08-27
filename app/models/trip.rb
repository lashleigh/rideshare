class Trip
  include MongoMapper::Document
  before_create :create_google_and_trip_options

  key :origin,       String, :required => true
  key :destination,  String, :required => true
  key :distance,     Float,  :required => true #in meters
  key :duration,     Float,  :required => true #in hours
  key :route,        Array,  :required => true, :typecast => 'Array'
  key :encoded_poly, String, :required => true
 
  key :summary, String 
  key :tags, Array
  key :start_date, Date, :required => true
  key :start_time, String, :in => ["e", "m", "a", "l"]
  key :start_flexibility, Array

  one :google_options
  one :trip_options
  # many :routes
  # validates_presence_of :origin, :destination
  timestamps!

  scope :by_duration_in_hours, lambda {|low, high| where(:duration.gte => low*3600,  :duration.lte => high*3600) }
  scope :by_distance_in_miles, lambda {|low, high| where(:distance.gte => low*1609.344, :distance.lte => high*1609.344) }

  #scope :find_all_starting_in, lambda {|start| where(:origin => start) }
  scope :find_all_starting_in,  lambda {|start,  options={}| where(:id => {'$in' => Trip.starts_at(start, options)})}
  scope :find_all_finishing_in, lambda {|finish, options={}| where(:id => {'$in' => Trip.ends_at(finish, options)})}
  scope :find_all_exact_match,  lambda {|s,ends, options={}| where(:id => {'$in' => Trip.starts_at(s, options) & Trip.ends_at(ends, options) }) }
  scope :find_all_near,         lambda {|coords, options={}| where(:id => {'$in' => Trip.near_wrapper(coords)}) } 

  def self.starts_at(coords, options = {}) 
    options[:radius] ||= 60
    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end
    Trip.all.select {|trip| Geocoder::Calculations::distance_between(trip.route[0], coords) < options[:radius] }.map {|t| t.id }
  end

  def self.ends_at(coords, options ={}) 
    options[:radius] ||= 60
    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end
    Trip.all.select {|trip| Geocoder::Calculations::distance_between(trip.route.last, coords) < options[:radius] }.map {|t| t.id }
  end

  def self.near_wrapper(coords, options={})
    if String === coords || Float === coords[0]
      Trip.near(coords, options)
    else
      Trip.intersect(coords, options)
    end
  end

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

    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end

    trips = {}
    Trip.all.each do |trip|
      dist = trip.route.map{|point| Geocoder::Calculations::distance_between(point, coords)}.min
      trips[trip.id] = dist
    end
    return trips.select {|k, v| v < options[:radius]}.keys
  end

  def self.include_ordered(coords_array, options={})
    res = Trip.near_with_index(coords_array[0], options)

    if coords_array[1]
      (1..coords_array.length-1).each do |i|
        f = Trip.near_with_index(coords_array[i], options)
        res.keep_if {|sk, sv| f.include? sk and sv["index"] < f[sk]["index"] }
        res.each{|sk, sv| sv["index"] = f[sk]["index"] }
      end
    end
    return res.keys
  end
  def self.includes_start_finish(start, finish, options={})
    s = Trip.near_with_index(start, options)
    f = Trip.near_with_index(finish, options)
    s.keep_if {|sk, sv| f.include? sk and sv["index"] < f[sk]["index"] }.keys
  end

  def self.near_with_index(coords, options = {})
    options[:radius] ||= 60

    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end

    trips = {}
    Trip.all.each do |trip|
      dist_with_point = trip.route.map{|point| [Geocoder::Calculations::distance_between(point, coords), point]}.min
      trips[trip.id] = {"dist" => dist_with_point[0], "index" => trip.route.index(dist_with_point[1])}
    end
    return trips.select {|k, v| v["dist"] < options[:radius]} #.keys
  end

  def distance_between_points
    zipped = route.slice(1..-1).zip(route)
    distances = zipped.map {|point1, point2| Geocoder::Calculations::distance_between(point1, point2) }
    avg = distances.sum / distances.length
    max = distances.max
    min = distances.min
    return {"avg" => avg, "max" => max, "min" => min}
  end

  private
  def create_google_and_trip_options
    self.google_options = GoogleOptions.new
    self.trip_options = TripOptions.new
  end
end
