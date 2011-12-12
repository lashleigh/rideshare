class Craigslist
  include MongoMapper::Document

  key :city,  String, :required => true
  key :state, String
  key :href,  String, :required => true
  key :coords, Array, :required => true
  key :approved, Boolean, :default => false
  key :last_feed, Time
  ensure_index [[ :coords, '2d']]

  validate :coordinate_range
  many :requests

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
  def feed_url
    href+'rid/index.rss'
  end
  def import_feed
    feedzirra = Feedzirra::Feed.fetch_and_parse(self.feed_url).entries
    ashleigh_id = User.find_by_name_and_admin('ashleigh baumgardner', true).id
    index = 0
    entry = feedzirra[0]
    while entry and entry.published and entry.published > self.last_feed
      Request.from_craigslist(entry, self, ashleigh_id)
      index+=1
      entry = feedzirra[index]
    end
    self.last_feed = feedzirra[0].published
    self.save
    return self.requests
  end

  def self.find_all_near_route(trip, options={})
    options[:radius] ||= 25.0
    in_bounds = where(:coords => {'$within' => {'$box' => trip.bounds_to_box(options[:radius])}}).all
    close_enough = []
    trip.route.each do |trip_coords| 
      in_bounds.each do |c|
        if Geocoder::Calculations::distance_between(c.coords, trip_coords) < options[:radius]
          close_enough.push(c.id)
          in_bounds.delete(c)
          break
        end
      end
    end
    return close_enough
  end
end
