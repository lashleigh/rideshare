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
  def option_for_shared_driving(val) 
    shared_driving_ops
      .map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
      .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
  
  def option_for_max_passengers(val)
    max_passengers_ops
      .map{|v| [v, v==val ? "selected='selected'" : ""]}
      .map{|a,b| "<option value=#{a} #{b}>#{a}</option>"}.join.html_safe
  end

  def option_for_max_luggage(val)
    max_luggage_ops
      .map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
      .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end

  def shared_driving_ops
    [["Meh", 0], ["Yes, a must", 1], ["No, I will do all driving", 2]]
  end
  def max_passengers_ops
    (0..8)
  end
  def max_luggage_ops
    [["None", 0], ["Small backpack", 1], ["Several bags", 2], ["As much as you want", 3]]
  end
  def car_type_ops
    [["Compact", 0], ["Full size", 1], ["SUV", 2], ["Truck", 3]]
  end
end
