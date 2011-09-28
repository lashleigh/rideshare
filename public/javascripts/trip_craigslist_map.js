var map;
var bounds = new google.maps.LatLngBounds();
var current_city;
var base_height;

$(function() {
  var myOptions = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: coords_to_google_point(trip.route[0])
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  drawRoute();
  base_height = (-1)*$("#craigslist_container").height()/2;
  for(var i = 0; i < craigslists.length; i++) {
    new Craigslist(craigslists[i]);
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

