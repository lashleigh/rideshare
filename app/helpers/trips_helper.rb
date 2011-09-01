module TripsHelper
  def static_map(trip)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=480x480&path=weight:5|color:0x00000099|enc:'
    a = "&markers=color:green%7Clabel:A%7C#{trip.route[0].join(",")}"
    b = "&markers=color:green%7Clabel:B%7C#{trip.route.last.join(",")}"
    w = trip.google_options.waypoints.map{|w| "&markers=size:mid%7Ccolor:blue%7C#{w.join(",")}"}.join
    basic+trip.encoded_poly+a+b+w+"&sensor=false"
  end

  def small_static_map(trip, ori, des)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=150x120&path=weight:5|color:0x00000099|enc:'
    a = "&markers=size:mid%7Ccolor:green%7Clabel:A%7C#{trip.route[0].join(",")}"
    b = "&markers=size:mid%7Ccolor:green%7Clabel:B%7C#{trip.route.last.join(",")}"
    d = "&markers=size:mid%7Ccolor:red%7Clabel:B%7C#{des.join(",")}" if des
    c = "&markers=size:mid%7Ccolor:red%7Clabel:A%7C#{ori.join(",")}" if ori
    c ||= ""
    d ||= ""
    basic+trip.encoded_poly+a+b+c+d+"&sensor=false"
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

  def tweet_text(trip)
  url = "http://rideshare.com/trips/#{trip.id}"
  text = trip.title_minus_country
  if trip.trip_options.cost
    text = text+" for $#{trip.trip_options.cost}"
  end
  "http://twitter.com/intent/tweet?url=#{url}&via=RideShare&text=#{text}"
  end
  def facebook_text(trip)
  url = "http://rideshare.com/trips/#{trip.id}"
  text = trip.title_minus_country
  "http://www.facebook.com/sharer.php?u=#{url}&t=#{text}"
  end
end
