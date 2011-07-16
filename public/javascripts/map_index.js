var geocoder = new google.maps.Geocoder();

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

  start_mark = drawMark("Seattle", 45, -122);
  end_mark = drawMark("New York", 40, -75);
  update_hidden_fields(start_mark, "origin");
  update_hidden_fields(end_mark, "destination");

  var geo = new google.maps.Geocoder();       
  $(function() {
    $("#origin").autocomplete({
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
});
function update_hidden_fields(marker, which) {
  new google.maps.event.addListener(marker, 'dragend', function(evt) {
    var position = marker.getPosition()
    $("#"+which+"_lat").val(position.lat());
    $("#"+which+"_lon").val(position.lng());
    var address = $.get("http://maps.googleapis.com/maps/api/geocode/json?latlng="+position.lat()+","+position.lng()+"&sensor=true")
    console.log(address);
  });
  new google.maps.event.addListener(marker, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2>'+ name +'</h2></div>');
    infoWindow.open(map);
  });

}
function drawMark(name, lat, lon) {
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lon),
    map: map,
    title: name,
    draggable: true,
  });
  return marker;
}
function codeAddress() {
  deleteOverlays();
  var address = document.getElementById("origin").value;
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      $(results).each(drawResult);
      savedResult = results[0];
      savedAddress = savedResult.formatted_address;
      savedName = savedResult.address_components[0].long_name;
      savedLatLng = savedResult.geometry.location;
      placeMap.setCenter(savedLatLng);

    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}

