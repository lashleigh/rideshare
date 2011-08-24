$(function() {
  $('.edit').editable('jeditable', {
    id : 'type', 
    name : 'value',
    submitdata : {'id' : trip.id }, 
  });

  $('#max_passengers').editable('jeditable', {
    id : 'type', 
    name : 'value',
    type : 'select',
    onblur : 'submit',
    data : ops["max_passengers"],
    submitdata : {'id' : trip.id, 'nested' : 'trip_options' }, 
  });
  $('#shared_driving').editable(mysubmitmethod, {
    id : 'type', 
    name : 'value',
    type : 'select',
    submit   : 'OK',
    data : ops["shared_driving"],
    submitdata : {'id' : trip.id, 'nested' : 'trip_options' }, 
  });
  $('#max_luggage').editable(mysubmitmethod, {
    id : 'type', 
    name : 'value',
    type : 'select',
    submit   : 'OK',
    data : ops["max_luggage"],
    submitdata : {'id' : trip.id, 'nested' : 'trip_options' }, 
  });

  function mysubmitmethod(value, settings) { 
    var to_return = value;
    var type = $(this).attr("id");
    var returned = $.ajax({
           url: "jeditable", 
           type: "POST",
           data: {'id' : trip.id, 'nested' : 'trip_options', 'type' : type, 'value' : value},
           dataType : "json",
           complete : function (xhr, textStatus) 
           {
             //alert(textStatus);
           }
        });
    if( ops[type] ) {
      to_return = ops[type][value];
    }
    console.log(this);
    console.log(value);
    console.log(settings);
    console.log(returned);
    return(to_return );
  }
})
