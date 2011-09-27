class Craigslist
  include MongoMapper::Document
  include Geocoder::Model::MongoMapper

  key :city, String
  key :state, String
  key :href, String
  key :approved, Boolean, :default => false
  key :coords, Array
  ensure_index [[ :coords, '2d']]

  def self.find_all_near_route(trip, options={})
    options[:radius] ||= 25.0
    in_bounds = where(:coords => {'$within' => {'$box' => trip.bounds_to_box(options[:radius])}}).all
    close_enough = []
    in_bounds.each do |c|
      trip.route.each do |trip_coords| 
        if Geocoder::Calculations::distance_between(c.coords, trip_coords) < options[:radius]
          close_enough.push(c)
          break
        end
      end
    end
    return close_enough.sort{|a, b| a.coords <=> b.coords }
  end
end
