var map;
var bounds = new google.maps.LatLngBounds();
var infoWindow = new google.maps.InfoWindow();

$(function() {
  on_load();
  var myOptions = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: new google.maps.LatLng(trip.route[0][0], trip.route[0][1])
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  //$(cities).each(drawCity);
  drawRoute();
  for(var i in cities) { drawCity(i, cities[i]) }
  map.fitBounds(bounds);

});
function on_load() {
  set_heights();
  $(window).resize(set_heights);
}
function drawRoute() {
  var routeLatLng = [];
  for(var i=0; i<trip.route.length; i++) {
    routeLatLng.push(new google.maps.LatLng(trip.route[i][0], trip.route[i][1]));
  }
  bounds.extend(routeLatLng[0]);
  bounds.extend(routeLatLng[routeLatLng.length-1])

  var mapLine = new google.maps.Polyline({
      map           : map,
      strokeColor   : '#0000ff',
      strokeOpacity : 0.6,
      strokeWeight  : 4,
      path: routeLatLng
  });
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+trip.id+'">'+ trip.id +'</a></h2></div>');
    infoWindow.position = event.latLng;
    infoWindow.open(map);
  });
}
function drawCity(i, placeObj) {
  var cityLatLng = new google.maps.LatLng(placeObj.coords[0], placeObj.coords[1]);
  var craigs_id = "#craigs_"+placeObj.id;
  var marker = new google.maps.Marker({
    position: cityLatLng,
    map: map,
    title: placeObj.city,
    icon: "/images/red_marker.png"
  });  
  new google.maps.event.addListener(marker, 'mouseover', function() {
    $(craigs_id).css({backgroundColor: "#005555"}); 
  });
  new google.maps.event.addListener(marker, 'mouseout', function() {
    $(craigs_id).css({backgroundColor: "#ffffff"}); 
  });
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form">'
                         +'<h2><a href="'+placeObj.href+'rid">'+ placeObj.city+", "+placeObj.state +'</a></h2>'
                         +'</div>');
    infoWindow.open(map, marker);
  });
  $(craigs_id).hover(
    function() { 
      marker.setIcon("/images/yellow_marker.png");
      $(this).css({backgroundColor: "#005555"}); 
    }, function() {
      marker.setIcon("/images/red_marker.png");
      $(this).css({backgroundColor: "#ffffff"}); 
    }
  ).click(function() {
    //map.panTo(cityLatLng);
    //map.setZoom(14);
    infoWindow.setContent('<div class="place_form">'
                         +'<h2><a href="'+placeObj.href+'rid">'+ placeObj.city+", "+placeObj.state +'</a></h2>'
                         +'</div>');
    infoWindow.open(map, marker);
    }
  );
  bounds.extend(cityLatLng);
}
