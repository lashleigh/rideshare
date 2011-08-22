class Route
  include MongoMapper::Document

  key :name, String
  key :route, Array
  key :encoded_poly, String
  timestamps!

  one :google_options
  belongs_to :trip

end
