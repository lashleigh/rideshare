var map;
var infoWindow = new google.maps.InfoWindow();
var origin, destination;
var origin_trips, destination_trips, perfect_matches;
var bounds = new google.maps.LatLngBounds();

$(function() {
    origin = result_hash["origin"]["loc"]
  destination = result_hash["destination"]["loc"]
  origin_trips = result_hash["origin_trips"]
  destination_trips = result_hash["destination_trips"]
  perfect_matches = result_hash["perfect_matches"]

  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(origin.coords[0], origin.coords[1]),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  $(origin).each(drawCity);
  $(destination).each(drawCity);
  for(var i = 0; i<origin_trips.length; i++) { drawRoute(origin_trips[i]) }
  for(var i = 0; i<destination_trips.length; i++) { drawRoute(destination_trips[i]) }
  for(var i = 0; i<perfect_matches.length; i++) { drawRoute(perfect_matches[i]) }
  //$(origin_trips).each(drawRouteFromPlaces);
  //$(destination_trips).each(drawRouteFromPlaces);
  //$(perfect_matches).each(drawRouteFromPlaces);
  map.fitBounds(bounds);
});
function drawRoute(routeObj) {
  var color = convert(routeObj.bearing, 1, 1);
  var routeLatLng = [];
  for(var i=0; i<routeObj.route.length; i++) {
    var coords = cities_hash[routeObj.route[i]].coords;
    routeLatLng.push(new google.maps.LatLng(coords[0], coords[1]));
  }

  var mapLine = new google.maps.Polyline({
      map : map,
      strokeColor   : color,
      strokeOpacity : 0.7,
      strokeWeight  : 4,
      path: routeLatLng
  });
  mapLine.setMap(map);
  new google.maps.event.addListener(mapLine, 'mouseover', function() {
    this.setOptions({strokeWeight: 8, strokeOpacity: 1.0});
  });
  new google.maps.event.addListener(mapLine, 'mouseout', function() {
    this.setOptions({strokeWeight: 4, strokeColor:  color});
  });
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+routeObj.id+'">'+ routeObj.id +'</a></h2><p>'+routeObj.bearing+'</div>');
    infoWindow.setPosition(event.latLng);
    infoWindow.open(map);
  });
}

