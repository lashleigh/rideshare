class GoogleOptions
  include MongoMapper::EmbeddedDocument

  key :avoid_highways, Boolean, :default => false
  key :avoid_tolls, Boolean, :default => false
  key :waypoints, Array

  belongs_to :trip
  def waypoints=(x)
    if String === x and !x.blank?
      super(ActiveSupport::JSON.decode(x))
    else
      super(x)
    end
  end
end
