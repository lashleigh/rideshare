function drawRouteFromPlaces(i, routeObj) {
  var routeLatLng = [];
  for(var i=0; i<routeObj.route.length; i++) {
    var coords = cities_hash[routeObj.route[i]].coords;
    routeLatLng.push(new google.maps.LatLng(coords[0], coords[1]));
  }

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
    position: new google.maps.LatLng(placeObj.coords[0], placeObj.coords[1]),
    map: map,
    title: placeObj.address,
    //draggable: true,
  });
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form">'
                         +'<h2><a href="/places/'+placeObj.id+'">'+ placeObj.address +'</a></h2>'
                         +'<p>Num rides: '+placeObj.num_rides+'</p>'
                         +'</div>');
    infoWindow.open(map, marker);
  });
}
