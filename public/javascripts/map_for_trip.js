var map;
var mapLine;
var r = [];

$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  $(trips).each(drawRouteFromPlaces);
  drawRoute();
  /*new google.maps.event.addListener(map, 'click', function(event) {
    var path = mapLine.getPath();
    path.push(event.latLng);
    mapLine.stopEdit();
    mapLine.runEdit();
  });*/ 
  $(".city_select").change(function(){
    var where = $(this).index();
    var which = $(this).val();
    var coords = cities_hash[which].coords;
    var latlng = new google.maps.LatLng(coords[0], coords[1]);
    mapLine.getPath().removeAt(where);
    mapLine.getPath().insertAt(where, latlng);
    console.log($(this).find(":selected"))
    return false;
  })
});
function drawRouteFromPlaces(i, routeObj) {
  var routeLatLng = [];
  for(var i=0; i<routeObj.route.length; i++) {
    var coords = cities_hash[routeObj.route[i]].coords;
    routeLatLng.push(new google.maps.LatLng(coords[0], coords[1]));
  }

  var mapLine = new google.maps.Polyline({map : map,
      strokeColor   : '#555555', 
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  mapLine.setMap(map);
}
function drawRoute() {
  var routeLatLng = [];
  for(var i=0; i<trip.route.length; i++) {
    var coords = cities_hash[trip.route[i]].coords;
    routeLatLng.push(new google.maps.LatLng(coords[0], coords[1]));
  }

  mapLine = new google.maps.Polyline({map : map,
      strokeColor   : '#ff0000',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  //mapLine.runEdit(true);
  mapLine.setMap(map);
}
function saveTrip() {
  r = [];
  var places = $(".city_select");
  for(var i=0; i<places.length; i++) {
    r.push($(places[i]).find(":selected").val());
  }
  r = JSON.stringify(r);

  $.post("/trips/update_location", {id: trip.id, route: r})
}
