module TripsHelper
  def static_map(trip)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=350x350&path=weight:5|color:0x00000099|enc:'
    a = "&markers=color:green%7Clabel:A%7C#{trip.route[0].join(",")}"
    b = "&markers=color:green%7Clabel:B%7C#{trip.route.last.join(",")}"
    w = trip.google_options.waypoints.map{|w| "&markers=size:mid%7Ccolor:blue%7C#{w.join(",")}"}.join
    # There is a very good chance this will make the request string too large
    #craigs = Craigslist.find_all_near_route(trip)
    #craigs_string = ""
    #craigs.each {|c| craigs_string+="&markers=size:mid%7Ccolor:blue%7C#{c.coords.join(",")}"}
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

  def cost_of_gas(trip)
    return "%1.0f" % (3.60*trip.distance/(1609.344*20.0))
  end
  def link_text(trip)
    "linky.com"
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
  def email_text(trip)
    "mailto:?subject=#{trip.title_minus_country}&body=I found this trip on AWESOME RIDESHARING SITE DOT COM:%0d%0a%0d%0a%0d%0a%0d%0a#{trip.title_minus_country}%0d%0a%0d%0ahttp://rideshare.com/trips/#{trip.id}\n"
  end
end
