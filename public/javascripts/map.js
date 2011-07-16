var infoWindow = new google.maps.InfoWindow();
var map;

$(function() {
  // Initialize the map with default UI.
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  $(cities).each(drawCity);
  $(trips).each(drawRoute);

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
      strokeColor   : routeObj.has_car ? '#0000ff' : '#00ff00',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  mapLine.setMap(map);
  new google.maps.event.addListener(mapLine, 'mouseover', function() {
    this.setOptions({strokeWeight: 8, strokeColor: '#CD00CD'});
  });
  new google.maps.event.addListener(mapLine, 'mouseout', function() {
    this.setOptions({strokeWeight: 4, strokeColor:  routeObj.has_car ? '#0000ff' : '#00ff00'});
  });
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+routeObj.id+'">'+ routeObj.id +'</a></h2></div>');
    infoWindow.position = event.latLng;
    infoWindow.open(map);
  });
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

function drawInterstate() {
  //var georssLayer = new google.maps.KmlLayer('http://gmaps-samples.googlecode.com/svn/trunk/ggeoxml/cta.kml');
  var georssLayer = new google.maps.KmlLayer('Interstate5.kml');
  console.log(georssLayer);
  georssLayer.setMap(map);
}
