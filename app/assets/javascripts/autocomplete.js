function autocomplete(which) {
  which.autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "http://ws.geonames.org/searchJSON",
        dataType: "jsonp",
        data: {
          featureClass: "P",
          style: "full",
          maxRows: 12,
          name_startsWith: request.term,
          country : "US"
        },
        success: function( data ) {
          response( $.map( data.geonames, function( item ) {
            return {
              label: item.name + (item.adminCode1 ? ", " + item.adminCode1 : "") + ", " + item.countryCode,
              value: item.name + (item.adminCode1 ? ", " + item.adminCode1 : "") + ", " + item.countryCode,
            }
          }));
        }
      });
    },
    minLength: 2,
    select: function( event, ui ) {
      //log( ui.item ?
      //  "Selected: " + ui.item.label :
      //  "Nothing selected, input was " + this.value);
    },
    open: function() {
      $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
    },
    close: function() {
      $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
    }
  });
};

function gmaps_autocomplete(which) {
  var geo = new google.maps.Geocoder();       
  $(function() {
    which.autocomplete({
      source: function(request, response) {
          geo.geocode( {'address': request.term}, function(results, status) {
            response($.map(results, function(item) {
              return {
                label: item.formatted_address,
                value: item.formatted_address,
                viewport: item.geometry.viewport,
                location: item.geometry.location
              }
            }));
          })
        },
      minLength: 3,
    });
  });
}
