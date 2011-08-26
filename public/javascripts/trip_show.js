$(function() {

  $(".edit_trip_options").each(function() {
    console.log($(this).attr("id"))
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
      url: "jeditable", 
      type: "POST",
      data: {'id' : trip.id, 'nested' : 'trip_options', 'type' : type, 'value' : value},
      dataType : "json",
      success : function(data, xhr, textStatus) {
        if(data["value"] != "nil") {
          that.removeClass("unused_val")
        } else {
        }
      },
      complete : function (xhr, textStatus) {
        if(textStatus === "success") {
        }      
      }
    });
    if( ops[type] ) {
      to_return = ops[type][value];
    }
    //console.log(value);
    //console.log(settings);
    console.log(returned);
    return(to_return );
  }
})
