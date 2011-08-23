module TripsHelper
  def static_map(path)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=480x480&path=weight:5|color:0x00000099|enc:'
    basic+path+"&sensor=false"
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
    [["Meh", 0], ["Yes, a must", 1], ["No, I will do all driving", 2]]
      .map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
      .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
  
  def option_for_max_passengers(val)
    (0..8).map{|v| [v, v==val ? "selected='selected'" : ""]}
      .map{|a,b| "<option value=#{a} #{b}>#{a}</option>"}.join.html_safe
  end

  def option_for_max_luggage(val)
    [["None", 0], ["Small backpack", 1], ["Several bags", 2], ["As much as you want", 3]]
      .map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
      .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end

end
