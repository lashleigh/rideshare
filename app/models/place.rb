class Place
  include MongoMapper::Document
  include Geocoder::Model::MongoMapper
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  key :address, String
  key :coordinates, Array

end
