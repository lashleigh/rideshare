// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
