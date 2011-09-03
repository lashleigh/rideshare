$(function() {
  var csrf = $("head meta")[1].content;

  $(".edit_summary").editable('update_summary', {
     id : 'type', 
     name : 'value',
     cssclass : 'edit_summary',
     type : 'textarea',
     submit : 'OK',
     indicator : "Saving...",
     submitdata : {'id' : trip.id, "authenticity_token" : csrf}
  });

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
      url: "/trips/update_trip_options", 
      type: "POST",
      data: {'id' : trip.id, 'nested' : 'trip_options', 'type' : type, 'value' : value, "authenticity_token" : csrf} ,
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
      value = value.replace(/\$/g, "");
      if(value == value*1) {
        to_return = "$"+parseFloat(value).toFixed(2); //parseFloat(value.replace(/\$/g, ""));
      } else {
        to_return = this.revert; //false;
      }
    }

    //console.log(value);
    //console.log(settings);
    console.log(returned);
    return(to_return );
  }
})
