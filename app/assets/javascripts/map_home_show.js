var map;
var infoWindow = new google.maps.InfoWindow();
var bounds = new google.maps.LatLngBounds();
var base_height;
var current;

$(function() {
  //set_heights()
  //$(window).resize(set_heights);
  //handle_datepicker();
  if(trips.length > 0) {
    map = new google.maps.Map(document.getElementById("map_canvas"), {
      center: new google.maps.LatLng(trips[0].route[0][0], trips[0].route[0][1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true
    });
 
    base_height = (-1)*$("#trips_container").height()/2;
    for(var i = 0; i<trips.length; i++) { 
      new Trip(trips[i]);
    }
    map.fitBounds(bounds);
  }
});
function Trip(trip) {
  var me = this;

  this.raw = trip;
  this.trip_id = "#trip_"+trip.id;
  this.route = drawRoute(this);

  if(base_height) { 
    base_height += $(this.trip_id).height();
    this.scroll_height = base_height;
  }
  $(me.trip_id).hover(function() {
    me.highlight();
  }, function() {
    me.cancel();
  });
}
Trip.prototype.highlight = function() {
  $(this.trip_id).addClass("current_item");
  this.route.setOptions({strokeWeight: 6, strokeOpacity: 1.0});
  current = this;
}
Trip.prototype.cancel = function() {
  $(this.trip_id).removeClass("current_item");
  this.route.setOptions({strokeWeight: 4, strokeOpacity: 0.3});
}
function drawRoute(trip_object) {
  var trip = trip_object.raw;
  var color = "#8F0037";
  var mapLine = new google.maps.Polyline({
      map : map,
      strokeColor   : color,
      strokeOpacity : 0.3,
      strokeWeight  : 4,
      path: trip.route.map(function(c) {return new google.maps.LatLng(c[0], c[1]); }) 
  });
  new google.maps.event.addListener(mapLine, 'mouseover', function() {
    trip_object.highlight();
    $("#trips_container").stop().animate({scrollTop: trip_object.scroll_height}, 400)
  });
  new google.maps.event.addListener(mapLine, 'mouseout', function() {
    trip_object.cancel();
  });
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+trip.id+'">'+ trip.id +'</a></h2><p>'+trip.bearing+'</div>');
    infoWindow.setPosition(event.latLng);
    infoWindow.open(map);
  });
  bounds.extend(new google.maps.LatLng(trip.route[trip.route.length-1][0], trip.route[trip.route.length-1][1]));
  bounds.extend(new google.maps.LatLng(trip.route[0][0], trip.route[0][1]));
  return mapLine;
}
function set_heights() {
  var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - $("form").height() - 10;
  base = Math.max(base, parseInt($("#content").css("min-height")))
  $("#map_canvas").css("height", base+"px");
  $("#map_canvas").css("width", window.innerWidth+"px");
}

