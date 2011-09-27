var map;
var bounds = new google.maps.LatLngBounds();
var infoWindow = new google.maps.InfoWindow();
var current_city;
var base_height;

$(function() {
  set_heights();
  $(window).resize(set_heights);
  var myOptions = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: coords_to_google_point(trip.route[0])
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  drawRoute();
  base_height = (-1)*$("#craigslist_container").height()/2;
  for(var i = 0; i < cities.length; i++) {
    new City(cities[i]);
  }
});
function drawRoute() {
  bounds.extend(map.getCenter())
  bounds.extend(coords_to_google_point(trip.route[trip.route.length-1]))
  map.fitBounds(bounds);
  new google.maps.Polyline({
      map           : map,
      strokeColor   : '#0000ff',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: google.maps.geometry.encoding.decodePath(trip.encoded_poly)
  });
}
function City(city, heights) {
  this.raw = city;
  this.craigs_id = "#craigs_"+city.id;
  this.point = coords_to_google_point(city.coords);
  base_height += $(this.craigs_id).height();
  this.scroll_height = base_height;
  this.info_text = '<div class="place_form">'
                         +'<h2><a href="'+city.href+'rid">'+ city.city+", "+city.state +'</a></h2>'
                         +'</div>';
  var marker = new google.maps.Marker({
    position: this.point,
    map: map,
    title: city.city,
    icon: "/images/red_marker.png"
  });  
  this.marker = marker;
  set_events(this);
}
City.prototype = {
  mouseover_city: mouseover_city
}
function set_events(me) {
  new google.maps.event.addListener(me.marker, 'mouseover', function() {
    me.mouseover_city();
    $("#craigslist_container").stop().animate({scrollTop: me.scroll_height}, 400)
  });
  new google.maps.event.addListener(me.marker, 'click', function() {
    infoWindow.setContent(me.info_text);
    infoWindow.open(map, me.marker);
  });
  $(me.craigs_id).mouseover(function() {
    me.mouseover_city()
  }).click(function(){
    infoWindow.setContent(me.info_text);
    infoWindow.open(map, me.marker);
  });
}
function mouseover_city() {
  if(current_city){
    $(current_city.craigs_id).removeClass("current_item"); 
    current_city.marker.setIcon("/images/red_marker.png");
  }
  $(this.craigs_id).addClass("current_item"); 
  this.marker.setIcon("/images/yellow_marker.png");
  current_city = this;
}
function set_heights() {
  var h = Math.max($("#craigslist_container").outerHeight(), 400);
  $("#map_canvas").css("height", h+"px");
}
function coords_to_google_point(coords) {
  return new google.maps.LatLng(coords[0], coords[1]);
}
