var map;
var mapLine;
var r = []

$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  drawRoute();
});
function drawRoute() {
  var routeLatLng = [];
  for(var i=0; i<trip.route.length; i++) {routeLatLng.push(new google.maps.LatLng(trip.route[i][0], trip.route[i][1]))}

  mapLine = new google.maps.Polyline({map : map,
      strokeColor   : '#ff0000',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  mapLine.runEdit(true);
  mapLine.setMap(map);
}
function saveTrip() {
  r = [];
  var a = mapLine.getPath().getArray()
  for(var i=0; i < a.length; i++) {
    r.push([a[i].lat(), a[i].lng()])
  }
  r = JSON.stringify(r);

  $.post("/trips/update_location", {id: trip.id, route: r})
}
