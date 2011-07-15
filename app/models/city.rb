class City
  include MongoMapper::Document

  key :name, String
  key :lat, Float
  key :lon, Float
  timestamps!

end
