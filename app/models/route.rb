class Route
  include MongoMapper::Document

  key :name, String
  key :route, Array
  timestamps!

  belongs_to :user

end
