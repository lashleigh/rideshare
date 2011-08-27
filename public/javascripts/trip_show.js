$(function() {

  $(".edit_trip_options").each(function() {
    var data = ops[$(this).attr("id")];
    if( data === undefined) {
      $(this).editable(mysubmitmethod, {
        id : 'type', 
        name : 'value',
        type : 'text',
        submit : 'OK',
        indicator : "Saving...",
        submitdata : {'id' : trip.id, 'nested' : 'trip_options' }
        });
      } else {
      $(this).editable(mysubmitmethod, {
        id : 'type', 
        name : 'value',
        type : 'select',
        submit : 'OK',
        indicator : "Saving...",
        data : data,
        submitdata : {'id' : trip.id, 'nested' : 'trip_options' }
      });
    } 
  });

  function mysubmitmethod(value, settings) { 
    var to_return = value;
    var that = $(this);
    var type = that.attr("id");
    var returned = $.ajax({
      url: "update_trip_options", 
      type: "POST",
      data: {'id' : trip.id, 'nested' : 'trip_options', 'type' : type, 'value' : value},
      dataType : "json",
      success : function(data, xhr, textStatus) {
      that.removeClass("unused_val")
      console.log("success");
      },
      error : function (jqXHR, textStatus, errorThrown) {
        console.log(jqXHR, textStatus, errorThrown)
      }
    });
    if( ops[type] ) {
      to_return = ops[type][value];
    } else if(type === "cost") {
      to_return = "$"+parseFloat(value.replace(/\$/g, ""));
    }

    //console.log(value);
    //console.log(settings);
    console.log(returned);
    return(to_return );
  }
})
