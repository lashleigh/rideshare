var map;
var current_city;
var base_height;
var cities = [];

$(function() {
  var myOptions = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: coords_to_google_point([41.33288934687839,-96.05537127265626])
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  base_height = (-1)*$("#craigslist_container").height()/2;
  for(var i=0; i < craigslists.length; i++) {
    cities.push(new Craigslist(craigslists[i]));
  }
});

