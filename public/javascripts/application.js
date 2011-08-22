// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - 10;
  $("#content").css("min-height", base+"px");
  $(window).resize(function() {
    var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - 10;
    $("#content").css("min-height", base+"px");
  })
})

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
function set_heights() {
  var base = window.innerHeight - $("header").outerHeight() - $("footer").outerHeight() - 10;
  $("#content").css("height", base+"px");
  $("#map_canvas").css("height", base-10+"px");
  $("#detail_panel").css("height", base-10+"px")
}

