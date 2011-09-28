function Craigslist(craigslist, heights) {
  this.raw = craigslist;
  this.craigs_id = "#craigs_"+craigslist.id;
  this.point = coords_to_google_point(craigslist.coords);
  var marker = new google.maps.Marker({
    position: this.point,
    map: map,
    title: craigslist.city,
    icon: "/assets/red_marker.png"
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
  $(me.craigs_id).mouseover(function() {
    me.mouseover_city();
    if(!(map.getBounds().contains(me.marker.getPosition()))) {
      map.panTo(me.marker.getPosition());
    }
  })
}
function mouseover_city() {
  if(current_city){
    $(current_city.craigs_id).removeClass("current_item"); 
    current_city.marker.setIcon("/assets/red_marker.png");
    //current_city.marker.setZIndex(undefined);
  }
  $(this.craigs_id).addClass("current_item"); 
  this.marker.setIcon("/assets/yellow_marker.png");
  //this.marker.setZIndex(999);
  current_city = this;
}

