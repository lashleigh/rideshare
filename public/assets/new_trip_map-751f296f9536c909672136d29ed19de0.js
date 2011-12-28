function on_load(){set_heights(),$(window).resize(set_heights),origin_destination_not_blank(),$("#trip_origin").bind("focusout",origin_destination_not_blank),$("#trip_destination").bind("focusout",origin_destination_not_blank),$("#trip_start_date").bind("focusout",origin_destination_not_blank),$("#trip_start_date").datepicker({dateFormat:"D, dd M yy",minDate:0,maxDate:"+1M +10D"}),autocomplete($("#trip_origin")),autocomplete($("#trip_destination")),$(".ui-menu-item").live("click",function(){put_marker($(this).text(),!1)}),$(".adp-summary").live("click",function(){$(this).next().find(".adp-directions").toggle()}),$("#driving_options_link").toggle(function(){$(this).text("Hide options"),$("#driving_options").show()},function(){$(this).text("Show options"),$("#driving_options").hide()}),$("#start_date_options").click(function(){$(this).hide(),$("#trip_start_flexibility").show()}),$("#driving_options input").click(function(){directionsDisplay.directions!==undefined&&(save_waypoints(),calcRoute(waypoint_markers.map(function(a){return a.position})))})}function start_date_not_blank(){"Invalid Date"!=new Date($("#trip_start_date").val())&&($("#trip_origin").val().length*$("#trip_destination").val().length!=0?enable_save(!0):enable_save(!1))}function enable_save(a){a?($("#trip_submit").attr("disabled",!1),$("#trip_submit").removeClass("disable")):($("#trip_submit").attr("disabled",!0),$("#trip_submit").addClass("disable"))}function origin_destination_not_blank(){start=$("#trip_origin").val(),finish=$("#trip_destination").val(),start.length*finish.length!=0?(calcRoute(),"Invalid Date"!=new Date($("#trip_start_date").val())?enable_save(!0):enable_save(!1)):start.length!==0?(put_marker(start,$("#trip_origin")),enable_save(!1)):finish.length!==0&&(put_marker(finish,$("#trip_destination")),enable_save(!1))}function put_marker(a,b){geocoder.geocode({address:a},function(a,c){if(a.length!==0){var d=a[0].geometry.location;temp.setMap(map),temp.setPosition(d),b&&b.val(a[0].formatted_address),map.getBounds().contains(d)||map.setCenter(d)}else temp.setMap(null)})}function calcRoute(a){var b;a?b=a.map(function(a){return{location:a,stopover:!1}}):trip.google_options&&trip.google_options["waypoints"]!=undefined?b=trip.google_options.waypoints.map(function(a){return{location:new google.maps.LatLng(a[0],a[1]),stopover:!1}}):b=[];var c={origin:$("#trip_origin").val(),destination:$("#trip_destination").val(),waypoints:b,travelMode:google.maps.TravelMode[selectedMode],unitSystem:google.maps.UnitSystem[unit_system],avoidHighways:$("#avoid_highways:checked").length?!0:!1,avoidTolls:$("#avoid_tolls:checked").length?!0:!1};directionsService.route(c,function(a,b){b==google.maps.DirectionsStatus.OK?(directionsDisplay.setDirections(a),savePath(directionsDisplay.directions.routes[0].overview_path)):alert(b)})}function savePath(a){var b=a.map(function(a){return[a.lat(),a.lng()]});$("#trip_route").val(JSON.stringify(b))}function watch_waypoints(){$(".waypoint").remove(),clear_markers(waypoint_markers);var a=directionsDisplay.directions.routes[0].legs[0].via_waypoints;for(var b=0;b<a.length;b++){var c=new google.maps.Marker({map:map,position:new google.maps.LatLng(a[b].lat(),a[b].lng()),title:b.toString()});waypoint_markers.push(c),google.maps.event.addListener(c,"dblclick",function(){a.splice(parseInt(this.title),1),calcRoute(a),directionsDisplay.setOptions({preserveViewport:!0,draggable:!0})})}save_waypoints()}function save_waypoints(){var a=directionsDisplay.directions.routes[0].legs[0].via_waypoints.map(function(a){return[a.lat(),a.lng()]}),b=directionsDisplay.directions.routes[0].overview_polyline.points,c={};c.avoid_highways=$("#avoid_highways:checked").length?!0:!1,c.avoid_tolls=$("#avoid_tolls:checked").length?!0:!1,c.waypoints=a,$("#trip_google_options").val(JSON.stringify(c)),$("#trip_encoded_poly").val(b),$("#trip_distance").val(directionsDisplay.directions.routes[0].legs[0].distance.value),$("#trip_duration").val(directionsDisplay.directions.routes[0].legs[0].duration.value),$("#trip_origin").val(directionsDisplay.directions.routes[0].legs[0].start_address),$("#trip_destination").val(directionsDisplay.directions.routes[0].legs[0].end_address)}function clear_markers(a){if(a){for(var b=0;b<a.length;b++)a[b].setMap(null);a.length=0}}function drawCity(a,b){var c=new google.maps.Marker({position:new google.maps.LatLng(b.coords[0],b.coords[1]),map:map,title:b.city});google.maps.event.addListener(c,"click",function(){infoWindow.setContent('<div class="place_form"><h2><a href="'+b.href+'">'+b.city+", "+b.state+"</a></h2>"+"</div>"),infoWindow.open(map,c)})}function set_heights(){$("#map_canvas").css("height",$("#where_form").outerHeight()+150+"px")}var rendererOptions={draggable:!0,suppressInfoWindows:!0},directionsDisplay=new google.maps.DirectionsRenderer(rendererOptions),directionsService=new google.maps.DirectionsService,map,geocoder,waypoint_markers=[],infoWindow=new google.maps.InfoWindow,temp=new google.maps.Marker,selectedMode="DRIVING",unit_system="IMPERIAL";$(function(){geocoder=new google.maps.Geocoder,on_load();var a={zoom:4,mapTypeId:google.maps.MapTypeId.ROADMAP,center:new google.maps.LatLng(39,-96.5)};map=new google.maps.Map(document.getElementById("map_canvas"),a),directionsDisplay.setMap(map),directionsDisplay.setPanel(document.getElementById("directionsPanel")),google.maps.event.addListener(directionsDisplay,"directions_changed",function(){watch_waypoints(),savePath(directionsDisplay.directions.routes[0].overview_path)})})