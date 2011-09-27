var map;
var bounds = new google.maps.LatLngBounds();
var infoWindow = new google.maps.InfoWindow();
var markers_array = [];
var current_marker = 0;
var current_div;

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
  current_div = "#"+$(".craigslist_item")[0].id;
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
  i = parseInt(i);
  var marker = new google.maps.Marker({
    position: cityLatLng,
    map: map,
    title: placeObj.city,
    icon: "/images/red_marker.png"
  });  
  markers_array.push(marker);
  new google.maps.event.addListener(marker, 'mouseover', function() {
    $(current_div).removeClass("current_item"); 
    $(craigs_id).addClass("current_item"); 
    current_div = craigs_id;
    $("#craigslist_container").stop().animate({scrollTop: (i+1)*$(craigs_id).height()-$("#craigslist_container").height()/2}, 400)
    markers_array[current_marker].setIcon("/images/red_marker.png")
    marker.setIcon("/images/yellow_marker.png");
    current_marker = i;
  });
  google.maps.event.addListener(marker, 'click', function() {
    infoWindow.setContent('<div class="place_form">'
                         +'<h2><a href="'+placeObj.href+'rid">'+ placeObj.city+", "+placeObj.state +'</a></h2>'
                         +'</div>');
    infoWindow.open(map, marker);
  });
  $(craigs_id).mouseover( function() { 
    $(current_div).removeClass("current_item"); 
    $(this).addClass("current_item"); 
    current_div = craigs_id;
    markers_array[current_marker].setIcon("/images/red_marker.png")
    marker.setIcon("/images/yellow_marker.png");
    current_marker = i;
  }).click(function() {
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

function set_heights() {
  var h = Math.max($("#craigslist_container").outerHeight(), 400);
  $("#map_canvas").css("height", h+"px");
}
