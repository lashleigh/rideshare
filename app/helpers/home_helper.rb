module HomeHelper
  def start_date_array
    [["Use exact date above", "exact"], 
      ["1 day before",           "onebefore"], 
      ["1 day after",            "oneafter"], 
      ["1 day before and after", "one"], 
      ["2 days before and after","two"], 
      ["3 days before and after","three"]]
  end
  def create_options(val)
    val = "25" unless radius_array.map{|a,b| b}.include? val
    radius_array.map{|a,b| [a,b,b==val ? "selected='selected'" : ""]}
          .map{|a,b,c| "<option value=#{b} #{c}>#{a}</option>"}.join.html_safe
  end
  def radius_array
    [ ["< 10 mi", "10"], 
      ["< 15 mi", "15"],
      ["< 25 mi", "25"],
      ["< 35 mi", "35"],
      ["< 50 mi", "50"]]
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

end
