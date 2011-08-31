/**
 * A distance widget that will display a circle that can be resized and will
 * provide the radius in km.
 *
 * @param {google.maps.Map} map The map to attach to.
 *
 * @constructor
 */
function DistanceWidget(map) {
  this.set('map', map);
  this.set('position', map.getCenter());

  var marker = new google.maps.Marker({
    draggable: true,
    title: 'Move me!'
  });
  this.set('marker', marker)

  // Bind the marker map property to the DistanceWidget map property
  marker.bindTo('map', this);

  // Bind the marker position property to the DistanceWidget position
  // property
  marker.bindTo('position', this);

  // Create a new radius widget
  var radiusWidget = new RadiusWidget();

  // Bind the radiusWidget map to the DistanceWidget map
  radiusWidget.bindTo('map', this);

  // Bind the radiusWidget center to the DistanceWidget position
  radiusWidget.bindTo('center', this, 'position');

  // Bind to the radiusWidgets' distance property
  this.bindTo('distance', radiusWidget);

  // Bind to the radiusWidgets' bounds property
  this.bindTo('bounds', radiusWidget);

  // Bind to the radiusWidgets' marker
  this.set('sizer', radiusWidget.radius_marker);
}
DistanceWidget.prototype = new google.maps.MVCObject();


/**
 * A radius widget that add a circle to a map and centers on a marker.
 *
 * @constructor
 */
function RadiusWidget() {
  var circle = new google.maps.Circle({
    strokeWeight: 2
  });

  // Set the distance property value, default to 50km.
  this.set('distance', 50);

  // Bind the RadiusWidget bounds property to the circle bounds property.
  this.bindTo('bounds', circle);

  // Bind the circle center to the RadiusWidget center property
  circle.bindTo('center', this);

  // Bind the circle map to the RadiusWidget map
  circle.bindTo('map', this);

  // Bind the circle radius property to the RadiusWidget radius property
  circle.bindTo('radius', this);

  // Add the sizer marker
  this.addSizer_();
}
RadiusWidget.prototype = new google.maps.MVCObject();


/**
 * Update the radius when the distance has changed.
 */
RadiusWidget.prototype.distance_changed = function() {
  this.set('radius', this.get('distance') * 1000);
};


/**
 * Add the sizer marker to the map.
 *
 * @private
 */
RadiusWidget.prototype.addSizer_ = function() {
  var sizer = new google.maps.Marker({
    draggable: true,
    title: 'Drag me!'
  });

  this.set('radius_marker', sizer);
  sizer.bindTo('map', this);
  sizer.bindTo('position', this, 'sizer_position');

  var me = this;
  google.maps.event.addListener(sizer, 'drag', function() {
    // Set the circle distance (radius)
    me.setDistance();
  });
};


/**
 * Update the center of the circle and position the sizer back on the line.
 *
 * Position is bound to the DistanceWidget so this is expected to change when
 * the position of the distance widget is changed.
 */
RadiusWidget.prototype.center_changed = function() {
  var bounds = this.get('bounds');

  // Bounds might not always be set so check that it exists first.
  if (bounds) {
    var lng = bounds.getNorthEast().lng();

    // Put the sizer at center, right on the circle.
    var position = new google.maps.LatLng(this.get('center').lat(), lng);
    this.set('sizer_position', position);
  }
};


/**
 * Calculates the distance between two latlng points in km.
 * @see http://www.movable-type.co.uk/scripts/latlong.html
 *
 * @param {google.maps.LatLng} p1 The first lat lng point.
 * @param {google.maps.LatLng} p2 The second lat lng point.
 * @return {number} The distance between the two points in km.
 * @private
 */
RadiusWidget.prototype.distanceBetweenPoints_ = function(p1, p2) {
  if (!p1 || !p2) {
    return 0;
  }

  var R = 6371; // Radius of the Earth in km
  var dLat = (p2.lat() - p1.lat()) * Math.PI / 180;
  var dLon = (p2.lng() - p1.lng()) * Math.PI / 180;
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(p1.lat() * Math.PI / 180) * Math.cos(p2.lat() * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;
  return d;
};


/**
 * Set the distance of the circle based on the position of the sizer.
 */
RadiusWidget.prototype.setDistance = function() {
  // As the sizer is being dragged, its position changes.  Because the
  // RadiusWidget's sizer_position is bound to the sizer's position, it will
  // change as well.
  var pos = this.get('sizer_position');
  var center = this.get('center');
  var distance = this.distanceBetweenPoints_(center, pos);

  // Set the distance property for any objects that are bound to it
  this.set('distance', distance);
};

function map_for(map_canvas, info_id) {
  var map = new google.maps.Map(document.getElementById(map_canvas), {
    center: new google.maps.LatLng(37.790234970864, -122.39031314844),
    zoom: 8,
    disableDefaultUI: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  var distanceWidget = new DistanceWidget(map);

  google.maps.event.addListener(distanceWidget.sizer, 'dragend', function() {
    radius_info(distanceWidget, info_id);
  });

  google.maps.event.addListener(distanceWidget.marker, 'dragend', function() {
    codeLatLng(distanceWidget.marker, info_id)
  });
  widgets.push(distanceWidget);
}

function radius_info(widget, id) {
  $(id+"_radius").val(widget.get('distance'));
  $(id+"_info .radius").html('distance: ' + widget.get('distance'));
}

var widgets = [];
var geo_results;
var info = ["#origin",  "#destination"]

$(function() {
  map_for("map_for_origin", info[0]);
  map_for("map_for_destination", info[1]);
})

function codeLatLng(marker, id) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({'latLng': marker.getPosition()}, function(results, status) {
    geo_results = results;
    var best = 0;
    var taken = 4;
    if (status == google.maps.GeocoderStatus.OK) {
      results.forEach(function(r, i) {
             if(JSON.stringify(r.types) == '["locality","political"]'     && taken > 1){taken=1; best = i; console.log("local, political") } 
        else if(JSON.stringify(r.types) == '["neighborhood","political"]' && taken > 2){taken=2; best = i; console.log("neighbord, political") }
        else if(JSON.stringify(r.types) == '["postal_code"]'              && taken > 3){taken=3; best = i; }
        /*else if(JSON.stringify(r.types) == '["postal_code"]'              && taken > 3){taken=3; best = i; console.log("postal");
          var rescue_geo = new google.maps.Geocoder();
          rescue_geo.geocode({'address': results[i].formatted_address.replace(/ \d+/, "")}, function(rescue_r, rescue_status) {
            results[i] = rescue_r[0]
          });
        }*/
      })
      var res = results[best].formatted_address;
      $(id).val(res);
      $(id+"_info .position").html('Position: ' + res);
      //marker.setPosition(results[best].geometry.location);
    } else {
      alert("Geocoder failed due to: " + status);
    }
  });
}
function switching() {
      switch(JSON.stringify(r.types)) {
        case '["locality","political"]': best = i; break;
        case '["neighborhood","political"]': best = i; break;
        case '["postal_code"]': best = i; break;
      }
}