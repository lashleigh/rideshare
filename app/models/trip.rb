class Trip
  include MongoMapper::Document

  key :route, Array
  timestamps!

end
