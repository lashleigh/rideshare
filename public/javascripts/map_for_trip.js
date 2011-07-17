var map;
var infoWindow = new google.maps.InfoWindow();
var mapLine;
var r = [];
var hovering = false;
var hover_latlng;
var gYellowIcon = new google.maps.MarkerImage(
    "http://labs.google.com/ridefinder/images/mm_20_yellow.png",
    new google.maps.Size(12, 20),
    new google.maps.Point(0, 0),
    new google.maps.Point(6, 20));
var gRedIcon = new google.maps.MarkerImage(
  "http://labs.google.com/ridefinder/images/mm_20_red.png",
  new google.maps.Size(12, 20),
  new google.maps.Point(0, 0),
  new google.maps.Point(6, 20));
var gSmallShadow = new google.maps.MarkerImage(
  "http://labs.google.com/ridefinder/images/mm_20_shadow.png",
  new google.maps.Size(22, 20),
  new google.maps.Point(0, 0),
  new google.maps.Point(6, 20));


$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  $(trips).each(drawRouteFromPlaces);
  for(var i in cities_hash) { drawCity(i, cities_hash[i]) }
  drawRoute();

  /*new google.maps.event.addListener(map, 'click', function(event) {
    var path = mapLine.getPath();
    path.push(event.latLng);
    mapLine.stopEdit();
    mapLine.runEdit();
  });*/ 
  $( "#tags" ).autocomplete({
    source: avail_places
  });
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

function drawCity(i, placeObj) {
   var marker = new google.maps.Marker({
    position: new google.maps.LatLng(placeObj.coords[0], placeObj.coords[1]),
    map: map,
    title: placeObj.address,
    icon: gYellowIcon,
    shadow: gSmallShadow,
    //draggable: true,
  });
  new google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form"><h2><a href="/places/'+ placeObj.id+'">'+placeObj.address+'</a></h2></div>');
    infoWindow.open(map, marker);
  });
  new google.maps.event.addListener(marker, 'mouseover', function() {
     marker.setIcon(gRedIcon);
    infoWindow.setContent('<div class="place_form"><h2><a href="/places/'+ placeObj.id+'">'+placeObj.address+'</a></h2></div>');
     infoWindow.open(map, marker);
     hovering = true;
     hover_latlng = marker.getPosition();
  });
  new google.maps.event.addListener(marker, 'mouseout', function() {
     marker.setIcon(gYellowIcon);
     infoWindow.close();
     hovering = false;
  });
}
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
  mapLine.runEdit(true);
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
