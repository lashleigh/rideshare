var map;
var base_height;
var temp = new google.maps.Marker();
var geocoder = new google.maps.Geocoder();
var current;

$(function() {
  var myOptions = {
    zoom: 7,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: coords_to_google_point(craigslist.coords)
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  current = new Craigslist(craigslist);
  current.marker.setOptions({draggable:true});
  new google.maps.event.addListener(current.marker, 'dragend', function() {
    $("#craigslist_coords").val(point_to_coords(current.marker.getPosition()));
  })
  put_marker(current.raw.city+", "+current.raw.state, $("#craigslist_coords"))
});

function put_marker(where, which) {
  geocoder.geocode({'address': where}, function(results, status) {
    if(results.length !== 0) {
      var latlng = results[0].geometry.location;
      temp.setMap(map);
      temp.setPosition(latlng);
      if(which) {
        which.val(point_to_coords(latlng))
      }
      if(!map.getBounds().contains(latlng)) {
        map.setCenter(latlng)
      }
    } else {
    temp.setMap(null)
    }
  });
}
