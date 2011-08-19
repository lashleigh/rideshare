var rendererOptions = {
  draggable: true,
  suppressInfoWindows: true
  };
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
var directionsService = new google.maps.DirectionsService();
var map;
var geocoder;

// TODO let users set this
var selectedMode = "DRIVING"
var unit_system = "IMPERIAL"

$(function() {
  set_heights();
  $(window).resize(set_heights);
  geocoder = new google.maps.Geocoder();

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
    watch_waypoints();
    savePath(directionsDisplay.directions.routes[0].overview_path);
    });
  calcRoute()
});
function calcRoute(waypts) {

  var request = {
    origin: $("#trip_origin").val(),
    destination: $("#trip_destination").val(), 
    optimizeWaypoints: true,
    waypoints: waypts,
    travelMode: google.maps.TravelMode[selectedMode],
    unitSystem: google.maps.UnitSystem[unit_system]
  };
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
      savePath(directionsDisplay.directions.routes[0].overview_path);
    } else {
      console.log(status);
    }
  });
}
function savePath(path) {
  var path_as_array = path.map(function(a) { return [a.lat(), a.lng()];});
  $("#trip_route").val(JSON.stringify(path_as_array));
}
function click_actions() {
  $(".adp-summary").live("click", function() {
    $(this).next().find(".adp-directions").toggle();
  })
  $(".travel_icons li").live("click", function() {
    $(".travel_icons li").removeClass("selected").addClass("unselected");
    $(this).removeClass("unselected").addClass("selected");
    calcRoute();
  });
}
function watch_waypoints() {
  $(".waypoint").remove();
  var wpts = directionsDisplay.directions.routes[0].legs[0].via_waypoint;
  for(var i=0; i<wpts.length; i++) {
    code_latlng(wpts[i].location);
  }
}
function waypoint_html(as_str) {
  return '<div class="waypoint">'+as_str+'</div>'  
}
function code_latlng(latlng) {
  geocoder.geocode({'latLng': latlng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      console.log(results);
      $("#trip_origin_div").after(waypoint_html(results[1].formatted_address))
    } else {
      alert("Geocoder failed due to: " + status);
    }
  });
}
