var rendererOptions = {
  draggable: true,
  suppressInfoWindows: true
  };
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
var directionsService = new google.maps.DirectionsService();
var map;

// TODO let users set this
var selectedMode = "DRIVING"
var unit_system = "IMPERIAL"

$(function() {
  var myOptions = {
    zoom: 7,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: new google.maps.LatLng(45, -122)
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  directionsDisplay.setMap(map);
  directionsDisplay.setPanel(document.getElementById("directionsPanel"));

  google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {
    //computeTotalDistance(directionsDisplay.directions);
    //save_waypoints(directionsDisplay.directions);
    //drawPath(directionsDisplay.directions.routes[0].overview_path);
    //watch_waypoints();
  });
  calcRoute();
});
function calcRoute() {

  var request = {
    origin: origin,
    destination: destination, 
    travelMode: google.maps.TravelMode[selectedMode],
    unitSystem: google.maps.UnitSystem[unit_system]
  };
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
    } else {
      console.log(status);
    }
  });
}
