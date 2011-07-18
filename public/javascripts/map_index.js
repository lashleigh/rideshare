var geocoder = [new google.maps.Geocoder(), new google.maps.Geocoder]
var markersArray =[];

$('#home_search').live('click', function() {
  console.log(start_mark);
});
var map;
var start_mark; 
var end_mark; 
var infoWindow = new google.maps.InfoWindow();

$(function() {
  map = new google.maps.Map(document.getElementById("map_container"), {
    center: new google.maps.LatLng(42.03, -100.22),
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  /*$("#origin").autocomplete({
    source: avail_places
  });
  $("#destination").autocomplete({
    source: avail_places
  });*/
  autocomplete("#origin");
  autocomplete("#destination");

});
function autocomplete(which) {
  var geo = new google.maps.Geocoder();       
  $(function() {
    $(which).autocomplete({
      source: function(request, response) {
          geo.geocode( {'address': request.term}, function(results, status) {
            response($.map(results, function(item) {
              return {
                label: item.formatted_address,
                value: item.formatted_address,
                viewport: item.geometry.viewport,
                location: item.geometry.location
              }
            }));
          })
        },
      minLength: 3,
    });
  });
}
function place_origin_destination() {
  clearOverlays();
  codeAddress("origin", 0);
  codeAddress("destination", 1);
}
function draw_poly() {
  var geodesicOptions = {
    strokeColor: '#CC0099',
    strokeOpacity: 1.0,
    strokeWeight: 3,
    geodesic: true
  }
  var geodesic = new google.maps.Polyline(geodesicOptions);
  geodesic.setPath([markersArray[0].getPosition(), markersArray[1].getPosition()]);
  geodesic.setMap(map);
}
function drawResult(result, i) {
  var marker = new google.maps.Marker({
    position: result.geometry.location,
    map: map,
    title: result.address_components[0].long_name,
    draggable: false,
  });
  marker.setMap(map);
  markersArray.push(marker);
}
function codeAddress(which, i) {
  var address = document.getElementById(which).value;
  geocoder[i].geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      //$(results).each(drawResult);
      drawResult(results[0], i);

    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}

