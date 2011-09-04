var rendererOptions = {
  draggable: true,
  suppressInfoWindows: true
  };
var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
var directionsService = new google.maps.DirectionsService();
var map;
var geocoder;
var waypoint_markers = [];
var infoWindow = new google.maps.InfoWindow();

var temp = new google.maps.Marker();

// TODO let users set this
var selectedMode = "DRIVING"
var unit_system = "IMPERIAL"

$(function() {
  on_load();
  geocoder = new google.maps.Geocoder();

  var myOptions = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: new google.maps.LatLng(39, -96.5)
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

  //calcRoute(JSON.parse(trip.google_options["waypoints"]))
  //for(var i in cities) { drawCity(i, cities[i]) }
});
function on_load() {
  set_heights();
  $(window).resize(set_heights);
  origin_destination_not_blank();

  $("#trip_origin").bind("focusout", origin_destination_not_blank);
  $("#trip_destination").bind("focusout", origin_destination_not_blank);
  $("#trip_start_date").datepicker({
     dateFormat: 'D, dd M yy', 
     //defaultDate: +2,
     minDate: 0, 
     maxDate: "+1M +10D"
  });
  autocomplete($("#trip_origin"));
  autocomplete($("#trip_destination"));

  $(".ui-menu-item").live("click", function() {
    put_marker($(this).text(), false);
  });
  $(".adp-summary").live("click", function() {
    $(this).next().find(".adp-directions").toggle();
  })
  $("#driving_options_link").toggle(function() {
    $(this).text("Hide options");
    $("#driving_options").show();
  }, function() {
    $(this).text("Show options");
    $("#driving_options").hide();
    //$("#directionsPanel").toggle();
    });
  $("#start_date_options").click(function() {
    $(this).hide()
    $("#trip_start_flexibility").show();
  });
  $("#driving_options input").click(function() {
    if( directionsDisplay.directions !== undefined) {
      save_waypoints();
      calcRoute();
    }
  });
}
function start_date_not_blank() {
  if("Invalid Date" !=new Date($("#trip_start_date").val())) {
    if($("#trip_origin").val().length*$("#trip_destination").val().length != 0) {
      enable_save(true);
    } else { 
      enable_save(false); 
    }
  }
}
function enable_save(bool) {
  if(bool) {
    $("#trip_submit").attr("disabled", false);
    $("#trip_submit").removeClass("disable");
  } else {
    $("#trip_submit").attr("disabled", true);
    $("#trip_submit").addClass("disable");
  }
}
function origin_destination_not_blank() {
  start = $("#trip_origin").val();
  finish = $("#trip_destination").val();
  if(start.length*finish.length != 0) {
    calcRoute();
    if("Invalid Date" !=new Date($("#trip_start_date").val())) {
      enable_save(true);
    } else {
      enable_save(false);
    }
  } else if(start.length !== 0) {
    put_marker(start, $("#trip_origin"));
    enable_save(false);
  } else if(finish.length !== 0) {
    put_marker(finish, $("#trip_destination"));
    enable_save(false);
  }
}
function put_marker(where, which) {
  geocoder.geocode({'address': where}, function(results, status) {
    if(results.length !== 0) {
      var latlng = results[0].geometry.location;
      temp.setMap(map);
      temp.setPosition(latlng);
      if(which) {
        which.val(results[0].formatted_address)
      }
      if(!map.getBounds().contains(latlng)) {
        map.setCenter(latlng)
      }
    } else {
    temp.setMap(null)
    }
  });
}
function calcRoute(waypts) {
  var ary;
  if(waypts) {
    ary = waypts.map(function(wpt) {return {location: wpt, stopover: false};});
  } else if(trip.google_options && trip.google_options["waypoints"] != undefined ){
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
      alert(status);
    }
  });
}
function savePath(path) {
  var path_as_array = path.map(function(a) { return [a.lat(), a.lng()];});
  $("#trip_route").val(JSON.stringify(path_as_array));
}
function watch_waypoints() {
  $(".waypoint").remove();
  clear_markers(waypoint_markers);
  var wpts = directionsDisplay.directions.routes[0].legs[0].via_waypoints;
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
  var encoded = directionsDisplay.directions.routes[0].overview_polyline.points
  var google_options = {};
  google_options["avoid_highways"] = $("#avoid_highways:checked").length ? true : false;
  google_options["avoid_tolls"] = $("#avoid_tolls:checked").length ? true : false;
  google_options["waypoints"] = path;
  $("#trip_google_options").val(JSON.stringify(google_options));
  $("#trip_encoded_poly").val(encoded);
  $("#trip_distance").val(directionsDisplay.directions.routes[0].legs[0].distance.value);
  $("#trip_duration").val(directionsDisplay.directions.routes[0].legs[0].duration.value);
  $("#trip_origin").val(directionsDisplay.directions.routes[0].legs[0].start_address); 
  $("#trip_destination").val(directionsDisplay.directions.routes[0].legs[0].end_address);
}

function clear_markers(ma) {
  if(ma) {
    for(var i=0; i<ma.length; i++){
      ma[i].setMap(null);
    }
    ma.length = 0;
  }
}

function drawCity(i, placeObj) {
   var marker = new google.maps.Marker({
    position: new google.maps.LatLng(placeObj.coords[0], placeObj.coords[1]),
    map: map,
    title: placeObj.city,
    //draggable: true,
  });
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form">'
                         +'<h2><a href="'+placeObj.href+'">'+ placeObj.city+", "+placeObj.state +'</a></h2>'
                         +'</div>');
    infoWindow.open(map, marker);
  });
}

function set_heights() {
  $("#map_canvas").css("height", $("#where_form").outerHeight()+150+"px");
}
