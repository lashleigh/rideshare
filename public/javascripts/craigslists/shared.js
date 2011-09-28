function Craigslist(craigslist, heights) {
  this.raw = craigslist;
  this.craigs_id = "#craigs_"+craigslist.id;
  this.point = coords_to_google_point(craigslist.coords);
  this.info_text = '<div class="place_form">'
                         +'<h2><a href="'+craigslist.href+'rid">'+ craigslist.city+", "+craigslist.state +'</a></h2>'
                         +'</div>';
  var marker = new google.maps.Marker({
    position: this.point,
    map: map,
    title: craigslist.city,
    icon: "/images/red_marker.png"
  });  
  this.marker = marker;

  if(base_height) { 
    base_height += $(this.craigs_id).height();
    this.scroll_height = base_height;
    set_events(this);
  }
}
Craigslist.prototype = {
  mouseover_city: mouseover_city
}
function set_events(me) {
  new google.maps.event.addListener(me.marker, 'mouseover', function() {
    me.mouseover_city();
    $("#craigslist_container").stop().animate({scrollTop: me.scroll_height}, 400)
  });
  new google.maps.event.addListener(me.marker, 'click', function() {
    infoWindow.setContent(me.info_text);
    infoWindow.open(map, me.marker);
  });
  $(me.craigs_id).mouseover(function() {
    me.mouseover_city();
    if(!(map.getBounds().contains(me.marker.getPosition()))) {
      map.panTo(me.marker.getPosition());
    }
  }).click(function(){
    infoWindow.setContent(me.info_text);
    infoWindow.open(map, me.marker);
  });
}
function mouseover_city() {
  if(current_city){
    $(current_city.craigs_id).removeClass("current_item"); 
    current_city.marker.setIcon("/images/red_marker.png");
    //current_city.marker.setZIndex(undefined);
  }
  $(this.craigs_id).addClass("current_item"); 
  this.marker.setIcon("/images/yellow_marker.png");
  //this.marker.setZIndex(999);
  current_city = this;
}

