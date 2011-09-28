function coords_to_google_point(coords) {
  return new google.maps.LatLng(coords[0], coords[1]);
}
function point_to_coords(point) {
  return "["+[point.lat(), point.lng()]+"]";
}
