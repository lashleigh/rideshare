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

end
