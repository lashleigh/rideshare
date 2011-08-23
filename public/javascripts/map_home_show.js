var map;
var infoWindow = new google.maps.InfoWindow();
var bounds = new google.maps.LatLngBounds();

$(function() {
  set_heights()
  $(window).resize(set_heights);
  if(center != undefined) {
    map = new google.maps.Map(document.getElementById("map_canvas"), {
      center: new google.maps.LatLng(center[0], center[1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
 
    for(var i = 0; i<trips.length; i++) { drawRoute(trips[i]) }
    //$(origin_trips).each(drawRouteFromPlaces);
    //$(destination_trips).each(drawRouteFromPlaces);
    //$(perfect_matches).each(drawRouteFromPlaces);
    map.fitBounds(bounds);
  }
});
function drawRoute(trip) {
  var color = "#8F0037";
  var mapLine = new google.maps.Polyline({
      map : map,
      strokeColor   : color,
      strokeOpacity : 0.3,
      strokeWeight  : 4,
      path: trip.route.map(function(c) {return new google.maps.LatLng(c[0], c[1]); }) 
  });
  mapLine.setMap(map);
  new google.maps.event.addListener(mapLine, 'mouseover', function() {
    this.setOptions({strokeWeight: 6, strokeOpacity: 1.0});
  });
  new google.maps.event.addListener(mapLine, 'mouseout', function() {
    this.setOptions({strokeWeight: 4, strokeOpacity: 0.3});
  });
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+trip.id+'">'+ trip.id +'</a></h2><p>'+trip.bearing+'</div>');
    infoWindow.setPosition(event.latLng);
    infoWindow.open(map);
  });
  bounds.extend(new google.maps.LatLng(trip.route[trip.route.length-1][0], trip.route[trip.route.length-1][1]));
  bounds.extend(new google.maps.LatLng(trip.route[0][0], trip.route[0][1]));
}
function set_heights() {
  var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - $("form").height() - 10;
  base = Math.max(base, parseInt($("#content").css("min-height")))
  $("#map_canvas").css("height", base+"px");
  $("#map_canvas").css("width", window.innerWidth+"px");
}
