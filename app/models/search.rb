class Search
  include MongoMapper::Document

  key :origin,       String
  key :destination,  String
  key :origin_coords, Array
  key :destination_coords, Array
  key :origin_radius, Integer
  key :destination_radius, Integer

  validate :origin_or_destination
  #validate :valid_radii
  validate :valid_coordinates

  def origin_coords=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    elsif Array === x
      super(x.map{|i| i.to_f})
    else
      super(x)
    end
  end
  def destination_coords=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    else
      super(x)
    end
  end
  def destination=(x)
    if x.blank?
      super(nil)
    else
      super(x)
    end
  end
  def origin=(x)
    if x.blank?
      super(nil)
    else
      super(x)
    end
  end

  def origin_or_destination
    unless origin or destination
      errors.add(:origin_and_destination, "Can't both be blank")
    end
    #unless destination
    #  self.assign({:destination_radius => nil, :destination_coords => nil})
    #end
    #unless origin
    #  self.assign({:origin_radius => nil, :origin_coords => nil})
    #end
  end

  def valid_radii
    if origin
      if origin_radius.blank?
        self.assign({:origin_radius => 25})
      end
      unless (10..100).include? origin_radius
        errors.add(:origin_radius, "Must be between 10 and 100")
      end
    end
    if destination
      if destination_radius.blank?
        self.assign({:destination_radius => 25})
      end
      unless (10..100).include? destination_radius
        errors.add(:destination_radius, "Must be between 10 and 100")
      end
    end
  end
  def valid_coordinates
    if origin
      if origin_coords.empty?
        self.assign({:origin_coords => Geocoder.coordinates(origin)})
      end
      if origin_coords[0].is_a? String
      end
      unless origin_coords.is_a? Array and origin_coords.length == 2
        errors.add(:origin_coords, "The coordinates and not formatted porperly")
      end
      unless (-90..90).include? origin_coords[0] 
        errors.add(:origin_coords, "Latitude is not formatted properly")
      end
      unless (-180..180).include? origin_coords[1]
        errors.add(:origin_coords, "Longitude is not formatted properly")
      end
    end
    if destination
      if destination_coords.empty?
        self.assign({:destination_coords => Geocoder.coordinates(destination)})
      end
      unless destination_coords.is_a? Array and destination_coords.length == 2
        errors.add(:destination_coords, "The coordinates and not formatted porperly")
      end
      unless (-90..90).include? destination_coords[0] 
        errors.add(:destination_coords, "Latitude is not formatted properly")
      end
      unless (-180..180).include? destination_coords[1]
        errors.add(:destination_coords, "Longitude is not formatted properly")
      end
    end
    unless origin_coords.empty? or destination_coords.empty?
      if Geocoder::Calculations::distance_between(origin_coords, destination_coords) < 20
        errors.add(:coords, "Origin and destination are too close together")
      end
    end
  end

  def appropriate_response
    start = self.origin_coords
    finish = self.destination_coords
    if origin and destination
      return Trip.find_by_start_finish(start, finish, self)
    elsif origin
      return Trip.find_all_starting_in(start, self)
    else
      return Trip.find_all_finishing_in(finish, self)
    end
  end
  def custom_attributes
    allow = ["origin", "origin_coords", "origin_radius",
             "destination", "destination_coords", "destination_radius"]
    self.attributes.select{|k, v| allow.include? k }
    #h["origin_coords"] = ActiveSupport::JSON.encode(origin_coords) if h["origin_coords"]
    #h["destination_coords"] = ActiveSupport::JSON.encode(destination_coords) if h["destination_coords"]
    #return h
  end
end
