var mapLine;
var map;
var seattle = new google.maps.LatLng(47.609722, -122.333056);
var detroit = new google.maps.LatLng(42.331389, -83.045833);
var newyork = new google.maps.LatLng(43, -75);

$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  mapLine = new google.maps.Polyline({map : map,
                                      strokeColor   : '#ff0000',
                                      strokeOpacity : 0.6,
                                      strokeWeight  : 4,
                                      path:[seattle, detroit, newyork]
                                     });
  mapLine.runEdit(true);
  mapLine.setMap(map);
  new google.maps.event.addListener(map, 'click', function(event) {
    var path = mapLine.getPath();
    path.push(event.latLng);
    mapLine.stopEdit();
    mapLine.runEdit();
  }); 
});
