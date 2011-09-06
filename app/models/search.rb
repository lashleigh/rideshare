class Search
  include MongoMapper::Document

  key :origin,       String
  key :destination,  String
  key :origin_coords, Array
  key :destination_coords, Array
  key :origin_radius, Float
  key :destination_radius, Float

  validate :origin_or_destination
  validate :valid_coordinates

  def origin_or_destination
    if origin.blank? and destination.blank?
      errors.add( :origin_and_destination, "Can't both be blank")
    end
  end

  def ori_des
    origin.blank? and destination.blank?
  end
  def assign_coords
    unless origin.blank?
      self.origin_coords ||= Geocoder.coordinates(origin)
    end
  end
  def valid_coordinates
    unless origin.blank?
      unless (10..100).include? origin_radius
        errors.add(:origin_radius, "Must be between 10 and 100")
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

    unless destination.blank?
      unless (10..100).include? destination_radius
        errors.add(:destination_radius, "Must be between 10 and 100")
      end
      destination_coords ||= Geocoder.coordinates(destination) 
      unless destination_coords 
        errors.add(:destination_coords, "Ending coordinates could not be calculated")
      end
      unless (-90..90).include? destination_coords[0] and (-180..180).include? destination_coords[1]
        errors.add(:destination_coords, "Are not formatted properly")
      end
    end
  end

end
