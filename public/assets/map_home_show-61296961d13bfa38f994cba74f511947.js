function drawRoute(a){var b="#8F0037",c=new google.maps.Polyline({map:map,strokeColor:b,strokeOpacity:.3,strokeWeight:4,path:a.route.map(function(a){return new google.maps.LatLng(a[0],a[1])})});c.setMap(map),new google.maps.event.addListener(c,"mouseover",function(){this.setOptions({strokeWeight:6,strokeOpacity:1})}),new google.maps.event.addListener(c,"mouseout",function(){this.setOptions({strokeWeight:4,strokeOpacity:.3})}),new google.maps.event.addListener(c,"click",function(b){infoWindow.setContent('<div class="place_form"><h2><a href="/trips/'+a.id+'">'+a.id+"</a></h2><p>"+a.bearing+"</div>"),infoWindow.setPosition(b.latLng),infoWindow.open(map)}),bounds.extend(new google.maps.LatLng(a.route[a.route.length-1][0],a.route[a.route.length-1][1])),bounds.extend(new google.maps.LatLng(a.route[0][0],a.route[0][1]))}function set_heights(){var a=window.innerHeight-$("header").outerHeight()-$("footer").outerHeight()-$("form").height()-10;a=Math.max(a,parseInt($("#content").css("min-height"))),$("#map_canvas").css("height",a+"px"),$("#map_canvas").css("width",window.innerWidth+"px")}var map,infoWindow=new google.maps.InfoWindow,bounds=new google.maps.LatLngBounds;$(function(){if(center!=undefined&&trips.length>0){map=new google.maps.Map(document.getElementById("map_canvas"),{center:new google.maps.LatLng(center[0],center[1]),mapTypeId:google.maps.MapTypeId.ROADMAP,disableDefaultUI:!0});for(var a=0;a<trips.length;a++)drawRoute(trips[a]);map.fitBounds(bounds)}})