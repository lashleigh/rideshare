// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//no dont////= require_tree .

// Removes the overlays from the map, but keeps them in the array
function clearOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
  }
}

// Shows any overlays currently in the array
function showOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(map);
    }
  }
}

// Deletes all markers in the array by removing references to them
function deleteOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
    markersArray.length = 0;
  }
}
function toggle_favorite() {
  if(current_user) {
    $(".fav-toggle img").live("click", function(){
    if($(this).hasClass("on")) {
      $(this).removeClass("on").addClass("off");
      $(this).attr("src", "/images/fav-star-off.png")
    } else {
      $(this).removeClass("off").addClass("on");
      $(this).attr("src", "/images/fav-star-on.png")}
    })
  } /*else {
    throw("Please login to add favorites");
  }*/
}
