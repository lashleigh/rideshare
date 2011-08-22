module TripsHelper
  def static_map(path)
    basic = 'http://maps.googleapis.com/maps/api/staticmap?size=480x480&path=weight:5|color:0x00000099|enc:'
    basic+path+"&sensor=false"
  end

end
