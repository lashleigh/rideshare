class Trip
  include MongoMapper::Document
  before_create :create_google_and_trip_options
  before_save :set_start_date_to_midnight

  key :origin,       String, :required => true
  key :destination,  String, :required => true
  key :distance,     Float,  :required => true #in meters
  key :duration,     Float,  :required => true #in hours
  key :route,        Array,  :required => true, :typecast => 'Array'
  key :encoded_poly, String, :required => true
 
  key :start_date, Time, :required => true
  key :start_time, String, :in => ["any", "e", "m", "a", "l"], :default => "any"
  key :start_flexibility, String, :in => ["exact", "onebefore", "oneafter", "one", "two", "three"]
  key :summary, String 
  key :tags, Array
  key :views, Integer, :default => 0

  one :google_options
  one :trip_options
  belongs_to :user
  # many :routes
  # validates_presence_of :origin, :destination
  timestamps!

  scope :future, where(:start_date.gte => Time.now) 
  scope :by_duration_in_hours, lambda {|low, high| where(:duration.gte => low*3600,  :duration.lte => high*3600) }
  scope :by_distance_in_miles, lambda {|low, high| where(:distance.gte => low*1609.344, :distance.lte => high*1609.344) }

  scope :find_all_starting_in,  lambda {|start,  options={}| where(:id => {'$in' => Trip.starts_at(start, options)})}
  scope :find_all_finishing_in, lambda {|finish, options={}| where(:id => {'$in' => Trip.ends_at(finish, options)})}
  scope :find_all_in_date_range, lambda {|date, range| where(:start_date => {'$gte' => range[0].days.ago(date), '$lte' => range[1].days.since(date)})}
  scope :find_by_start_finish,  lambda {|start, finish, options={}| where(:id=>{'$in' => Trip.includes_start_finish(start, finish, options)} )}

  def route=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    else
      super(x)
    end
  end
  def google_options=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    else
      super(x)
    end
  end
  def self.starts_at(coords, options = {}) 
    options[:radius] ||= (options[:origin_radius] || 60)
    case coords
      when Array; coords
      when String; coords = Geocoder.coordinates(coords)
    end
    Trip.all.select {|trip| Geocoder::Calculations::distance_between(trip.route[0], coords) < options[:radius] }.map {|t| t.id }
  end

  def self.ends_at(coords, options ={}) 
    options[:radius] ||= (options[:destination_radius] || 60)
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
    options[:trips] ||= Trip.all

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
    options[:radius] = options[:origin_radius].to_f
    s = Trip.near_with_index(start, options)

    options[:radius] = options[:destination_radius].to_f
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
  def self.avail_dates(options={})
    dates = []
    options[:trips] ||= Trip.all
    options[:trips].each do |trip|
      dates += trip.date_range
    end
    return dates.reject {|d| d.past? }.uniq.sort.map{|d| d.to_formatted_s(:day_month_year).gsub(/^0/, "").gsub(/-0/,"-")}
  end
  def date_range
    start_date.array_from_range(self.flexibilty_hash[start_flexibility])
  end
  def in_range(date, range)
    start_date.array_from_range(self.flexibilty_hash[start_flexibility]) & date.array_from_range(self.flexibilty_hash[range])
  end

  def flexibilty_hash
    {"exact" => [0,0], "onebefore" => [1,0], "oneafter" => [0,1], "one" => [1,1], "two" => [2,2], "three" => [3,3]}
  end

  def get_bounds
    bound = Geocoder::Calculations::bounding_box(self.route[0], 60)
    self.route[1..-1].each do |point|
      new_bound = Geocoder::Calculations::bounding_box(point, 60)
      bound[0] = new_bound[0] if new_bound[0] > bound[0]
      bound[1] = new_bound[1] if new_bound[1] > bound[1]
      bound[2] = new_bound[2] if new_bound[2] > bound[2]
      bound[3] = new_bound[3] if new_bound[3] > bound[3]
    end
    return bound
  end

  def distance_between_points
    zipped = route.slice(1..-1).zip(route)
    distances = zipped.map {|point1, point2| Geocoder::Calculations::distance_between(point1, point2) }
    avg = distances.sum / distances.length
    max = distances.max
    min = distances.min
    return {"avg" => avg, "max" => max, "min" => min}
  end
  def title
    origin+" to "+destination
  end
  def title_minus_country
    origin[0..origin.rindex(",")-1]+" to "+destination[0..destination.rindex(",")-1]
  end

  private
  def create_google_and_trip_options
    self.google_options = GoogleOptions.new
    self.trip_options = TripOptions.new
  end
  def set_start_date_to_midnight
    self.start_date = self.start_date.utc.midnight
  end
end
