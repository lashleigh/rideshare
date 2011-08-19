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
  var cityLatLng = new google.maps.LatLng(placeObj.coords[0], placeObj.coords[1]);
   var marker = new google.maps.Marker({
    position: cityLatLng, 
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
  bounds.extend(cityLatLng)
}

function convert(h, s, v) {
  var chroma = s*v;
  var hPrime = (h%360)/60;
  var x = chroma* (1-Math.abs(hPrime % 2 - 1))

  var rgb_prime = rgbPrime(Math.floor(hPrime), chroma, x);

  var m = v-chroma;
  var rgb = []
  var hex = [] 
  for(i = 0; i<3; i++) {
    rgb[i] = 255*(rgb_prime[i]+m);
    hex[i] = toHex(rgb[i]);  
  }
  return "#"+hex.join("");
}
function rgbPrime(exp, chroma, x) {
  switch(exp) {
    case 0: return [chroma, x, 0]; break;
    case 1: return [x, chroma, 0]; break;
    case 2: return [0, chroma, x]; break;
    case 3: return [0, x, chroma]; break;
    case 4: return [x, 0, chroma]; break;
    case 5: return [chroma, 0, x]; break;
  }
}
function toHex(n) {
 n = parseInt(n,10);
 if (isNaN(n)) return "00";
 n = Math.max(0,Math.min(n,255));
 return "0123456789ABCDEF".charAt((n-n%16)/16)
      + "0123456789ABCDEF".charAt(n%16);
}
