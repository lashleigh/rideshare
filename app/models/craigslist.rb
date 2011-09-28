class Craigslist
  include MongoMapper::Document

  key :city,  String, :required => true
  key :state, String
  key :href,  String, :required => true
  key :coords, Array, :required => true
  key :approved, Boolean, :default => false
  ensure_index [[ :coords, '2d']]

  validate :coordinate_range
  def coords=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    else
      super(x)
    end
  end
  def coordinate_range 
    unless (-90..90).include? coords[0] 
      errors.add(:origin_coords, "Latitude is not formatted properly")
    end
    unless (-180..180).include? coords[1]
      errors.add(:origin_coords, "Longitude is not formatted properly")
    end
  end

  def self.find_all_near_route(trip, options={})
    options[:radius] ||= 25.0
    in_bounds = where(:coords => {'$within' => {'$box' => trip.bounds_to_box(options[:radius])}}).all
    close_enough = []
    in_bounds.each do |c|
      trip.route.each_with_index do |trip_coords, index| 
        if Geocoder::Calculations::distance_between(c.coords, trip_coords) < options[:radius]
          close_enough.push([c, index])
          break
        end
      end
    end
    return close_enough.sort{|a, b| a[1] <=> b[1]}.map{|a, i| a}
  end
end
