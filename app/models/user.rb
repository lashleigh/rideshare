class User
  include MongoMapper::Document

  key :name, String
  key :trip_ids, Array

  many :trips, :in => :trip_ids

end
