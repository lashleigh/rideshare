module TripsHelper
  def static_map(trip)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=480x480&path=weight:5|color:0x00000099|enc:'
    a = "&markers=color:green%7Clabel:A%7C#{trip.route[0].join(",")}"
    b = "&markers=color:green%7Clabel:B%7C#{trip.route.last.join(",")}"
    w = trip.google_options.waypoints.map{|w| "&markers=size:mid%7Ccolor:blue%7C#{w.join(",")}"}.join
    basic+trip.encoded_poly+a+b+w+"&sensor=false"
  end

  def trip_duration_in_words(duration)
    d = (duration/3600).to_i
    if d <= 22
      pluralize(d, 'hour')
    else
      day = d/24
      hour = d % 24
      if hour <= 2
        pluralize(day, 'day')
      elsif hour >= 22
        pluralize(day+1, 'day')
      else
        pluralize(day, 'day')+" and #{hour} hours"
      end
    end
  end
  def mash_up(opt, val)
    opt_hash[opt]
      .map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
      .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
  def select_val(opt, val)
    if opt_hash[opt]
      opt_hash[opt].select{|a,b| b==val}[0][0]
    elsif opt === "cost" and val != nil
      "$"+val.to_s
    end
  end
  def opt_hash
    {"shared_driving" => [["",nil],["Meh", 0], ["Yes, a must", 1], ["No, I will do all driving", 2]], 
     "max_passengers" => [["",nil]]+(0..8).zip(0..8), 
     "max_luggage"    => [["",nil],["None", 0], ["Small backpack", 1], ["Several bags", 2], ["As much as you want", 3]],
     "car_type"       => [["",nil],["Compact", 0], ["Full size", 1], ["SUV", 2], ["Truck", 3]]
    }
  end

end
