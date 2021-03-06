var map;
var infoWindow = new google.maps.InfoWindow();
var bounds = new google.maps.LatLngBounds();
var base_height;
var current;
var objects = {'starting' : [], 'ending' : [], 'passing_through' : [] };

$(function() {
  //set_heights()
  //$(window).resize(set_heights);
  //handle_datepicker();
  if(trips.length > 0) {
    map = new google.maps.Map(document.getElementById("map_canvas"), {
      center: new google.maps.LatLng(trips[0].route[0][0], trips[0].route[0][1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true
    });
 
    base_height = (-1)*$("#trips_container").height()/2;
    for(var i = 0; i<trips.length; i++) { 
      new Trip(trips[i], i);
    }
    map.fitBounds(bounds);
  }
  ['starting', 'ending', 'passing_through'].forEach(function(dir) {
    $('#'+dir).click(function() {
      if(!$(this).prop('checked')) {
        objects[dir].forEach(function(t) {t.hide();})
      } else {
        objects[dir].forEach(function(t) {t.show();})
      }
    });
    if(objects[dir].length === 0) {
      //$('#'+dir).prop('checked', false);
      $('#'+dir).prop('disabled', true);
      $('#'+dir).prev().css('opacity', 0.3);
    }
  });

});
function Trip(trip, index) {
  var me = this;

  this.raw = trip;
  this.index = index;
  this.direction = trip.direction;
  this.trip_id = "#trip_"+trip.id;
  this.route = drawRoute(this);

  if(base_height) { 
    base_height += $(this.trip_id).height();
    this.scroll_height = base_height;
  }
  $(me.trip_id).mouseover(function() {
    me.highlight();
  });
  me.direct();
}
Trip.prototype.direct = function() {
  if(this.direction < 0.15) {
    objects['ending'].push(this);
  } else if(this.direction > 0.85) {
    objects['starting'].push(this);
  } else {
    objects['passing_through'].push(this);
  }
}
Trip.prototype.highlight = function() {
  current ? current.cancel() : false;
  $(this.trip_id).addClass("current_item");
  this.route.setOptions({strokeWeight: 6, strokeOpacity: 1.0, zIndex : trips.length});
  current = this;
}
Trip.prototype.cancel = function() {
  $(this.trip_id).removeClass("current_item");
  this.route.setOptions({strokeWeight: 4, strokeOpacity: 0.5, zIndex : this.index});
}
Trip.prototype.hide = function() {
  $(this.trip_id).css('opacity', 0.15);
  this.route.setMap(null);
}
Trip.prototype.show = function() {
  $(this.trip_id).css('opacity', 1.0);
  this.route.setMap(map);
}
function drawRoute(trip_object) {
  var trip = trip_object.raw;
  var color = makeColor(Math.floor(trip.direction*(510))+1020); 
  var mapLine = new google.maps.Polyline({
      map : map,
      strokeColor   : color,
      strokeOpacity : 0.5,
      strokeWeight  : 4,
      path: trip.route.map(function(c) {return new google.maps.LatLng(c[0], c[1]); }) 
  });
  new google.maps.event.addListener(mapLine, 'mouseover', function() {
    trip_object.highlight();
    $("#trips_container").stop().animate({scrollTop: trip_object.scroll_height}, 400)
  });
  //new google.maps.event.addListener(mapLine, 'mouseout', function() {
  //  trip_object.cancel();
  //});
  new google.maps.event.addListener(mapLine, 'click', function(event) {
    infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+trip.id+'">'+ trip.id +'</a></h2><p>'+trip.bearing+'</div>');
    infoWindow.setPosition(event.latLng);
    infoWindow.open(map);
  });
  bounds.extend(new google.maps.LatLng(trip.route[trip.route.length-1][0], trip.route[trip.route.length-1][1]));
  bounds.extend(new google.maps.LatLng(trip.route[0][0], trip.route[0][1]));
  return mapLine;
}
function set_heights() {
  var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - $("form").height() - 10;
  base = Math.max(base, parseInt($("#content").css("min-height")))
  $("#map_canvas").css("height", base+"px");
  $("#map_canvas").css("width", window.innerWidth+"px");
}

