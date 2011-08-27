class TripOptions
  include MongoMapper::EmbeddedDocument

  key :cost, Float
  key :shared_driving, Integer
  key :max_passengers, Integer
  key :max_luggage, Integer
  key :car_type, Integer
  key :smoke_breaks, Integer

  validates_numericality_of :cost, :allow_blank => true
  validates_numericality_of :shared_driving, :allow_blank => true
  belongs_to :trip

  def all_used_attributes
    #self.keys.reject{|k, v| self[k].nil? or k == "_id"}.map{|k,v| [k, self[k]]}
    self.attributes.reject{|k, v| k=="_id" or v==nil}.to_a
  end
  def all_unused_attributes
    self.attributes.select{|k, v| k!="_id" and v==nil}.to_a
  end
  def all_attributes
    self.attributes.select{|k, v| k!="_id"}.to_a
  end

  def choose_from
    { "shared_driving" => {0=>"Meh", 1=>"Yes, a must", 2=>"No, I will do all driving", "selected" => self.shared_driving },
      "max_luggage"    => {0=>"None", 1=>"Small backpack", 2=>"Several bags", 3=>"As much as you want", "selected" => self.max_luggage},
      "car_type"       => {0=>"Compact", 1=>"Full size", 2=>"SUV", 3=> "Truck", "selected" => self.car_type}, 
      "max_passengers" => {0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, "selected" => self.max_passengers},
      "smoke_breaks"   => {0=>"Meh", 1=>"Yes, and the car is smoke friendly", 2=>"Breaks are fine, but no smoke in the car", 3=>"Hell no", "selected" => self.smoke_breaks}
    }
  end
  def view_for(opt)
    if choose_from[opt]
      choose_from[opt][self.attributes[opt]]
    elsif opt === "cost"
      "$"+self.cost.to_s unless self.cost.nil?
    else
      self.attributes[opt]
    end
  end
end
