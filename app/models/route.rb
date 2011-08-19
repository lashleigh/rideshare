class Route
  include MongoMapper::Document

  key :name, String
  key :route, Array
  key :trip_id, String
  timestamps!

  ensure_index [[:route,'2d']]

  belongs_to :trip

end
