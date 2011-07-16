class Trip
  include MongoMapper::Document

  key :name, String
  key :route, Array
  key :has_car, Boolean, :default => true
  key :will_drive, Boolean, :default => true
  timestamps!

end
