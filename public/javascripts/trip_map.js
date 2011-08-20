var rendererOptions = {
  draggable: true,
  suppressInfoWindows: true
  };
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
var directionsService = new google.maps.DirectionsService();
var map;
var geocoder;
var waypoint_markers = [];

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
  click_actions();
  calcRoute()
  //calcRoute(JSON.parse(trip.google_options["waypoints"]))
});
function calcRoute(waypts) {
  var ary;
  if(waypts) {
    ary = waypts.map(function(wpt) {return {location: wpt, stopover: false};});
  } else if(trip.google_options["waypoints"] != undefined ){
    ary = trip.google_options.waypoints.map(function(wpt) {return {location: new google.maps.LatLng(wpt[0], wpt[1]), stopover: false};})
  } else {
    ary = [];
  }

  var request = {
    origin: $("#trip_origin").val(),
    destination: $("#trip_destination").val(), 
    waypoints: ary,
    travelMode: google.maps.TravelMode[selectedMode],
    unitSystem: google.maps.UnitSystem[unit_system],
    avoidHighways: $("#avoid_highways:checked").length ? true:false,
    avoidTolls: $("#avoid_tolls:checked").length ? true:false
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
  $("#options_toggle a").click(function() {
    if( $(this).text() == "Show options") {
      $("#driving_options").show();
      $(this).text("Hide options");
    } else {
      $("#driving_options").hide();
      $(this).text("Show options");
    }
    });
    $("#driving_options input").click(function() {
      save_waypoints();
      calcRoute();
    });
}
function watch_waypoints() {
  $(".waypoint").remove();
  clear_markers(waypoint_markers);
  var wpts = directionsDisplay.directions.routes[0].legs[0].via_waypoints;
  //for(var i=0; i<wpts.length; i++) {
  //  code_latlng(wpts[i].location);
  //  }
  for(var i=0; i<wpts.length; i++) {
    var marker = new google.maps.Marker({
        map: map,
        //icon: "/images/blue_dot.png",
        position: new google.maps.LatLng(wpts[i].lat(), wpts[i].lng()),
        title: i.toString()
        });
    waypoint_markers.push(marker);
    google.maps.event.addListener(marker, 'dblclick', function() {
        wpts.splice(parseInt(this.title), 1);
        calcRoute(wpts);
        directionsDisplay.setOptions({ preserveViewport: true, draggable: true});
    });
  }
  save_waypoints();
}
function save_waypoints() {
  var path = directionsDisplay.directions.routes[0].legs[0].via_waypoints.map(function(a) { return [a.lat(), a.lng()];});
  var google_options = {};
  google_options["avoid_highways"] = $("#avoid_highways:checked").length ? true : false;
  google_options["avoid_tolls"] = $("#avoid_tolls:checked").length ? true : false;
  google_options["waypoints"] = path;
  $("#trip_google_options").val(JSON.stringify(google_options))
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
function clear_markers(ma) {
  if(ma) {
    for(var i=0; i<ma.length; i++){
      ma[i].setMap(null);
    }
    ma.length = 0;
  }
}

