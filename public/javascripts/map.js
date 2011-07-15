var infoWindow = new google.maps.InfoWindow();
var map;
var seattle = new google.maps.LatLng(47.609722, -122.333056);
var detroit = new google.maps.LatLng(42.331389, -83.045833);
var newyork = new google.maps.LatLng(43, -75);
var poly_routes= [];

$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  $(cities).each(drawCity);
  $(routes).each(drawRoute);
  
  //new google.maps.event.addListener(map, 'click', function(event) {
  //  var path = mapLine.getPath();
  //  path.push(event.latLng);
  //  mapLine.stopEdit();
  //  mapLine.runEdit();
  //}); 
});
function drawRoute(i, routeObj) {
  var routeLatLng = [];
  for(var i=0; i<routeObj.route.length; i++) {routeLatLng.push(new google.maps.LatLng(routeObj.route[i][0], routeObj.route[i][1]))}

  var mapLine = new google.maps.Polyline({map : map,
      strokeColor   : '#ff0000',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  poly_routes.push(mapLine);
  mapLine.runEdit(true);
  mapLine.setMap(map);
}

function drawCity(i, placeObj) {
   var marker = new google.maps.Marker({
    position: new google.maps.LatLng(placeObj.lat, placeObj.lon),
    map: map,
    title: placeObj.name,
    //draggable: true,
  });
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form"><h2>'+ placeObj.name +'</h2></div>');
    infoWindow.open(map, marker);
  });
}
