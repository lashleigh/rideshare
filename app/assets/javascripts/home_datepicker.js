
function available(_date) {
  dmy = _date.getDate() + "-" + (_date.getMonth()+1) + "-" + _date.getFullYear();
  if ($.inArray(dmy, availableDates) == -1) {
    return [false,"","Unavailable"];
  } else if($.inArray(_date.getTime(),_dates)>=0) {
      return [true,"highlighted-week","Week Range"];
  } else {
    return [true, ""];
  }
}
function highlight_dates() {
    $(".ui-state-default").parent().removeClass("highlighted-week")
    var current = $(".ui-state-default").index($(".ui-state-active"))
    var tolerance = flexibility[$("#start_flexibility :selected").val()];
    for (i = -tolerance[0]; i <= tolerance[1]; i++) {
      $($(".ui-state-default")[current+i]).parent().addClass("highlighted-week")
    }
}
function parse_date(i) {
  var d = availableDates[i].split("-");
  return new Date(d[2],d[1]-1,d[0]);
}
var _dates = [];
function handle_datepicker() {
  $("#start_flexibility").change(highlight_dates)
  $("#start_date").datepicker({
    altField: "#alternate",
    altFormat: "yy-mm-d",
    minDate: parse_date(0),
    maxDate: parse_date(availableDates.length-1),
    beforeShowDay: available,
    onSelect: function(_selectedDate){
      var _date = new Date(_selectedDate);
      _dates =[];
      var tolerance = flexibility[$("#start_flexibility :selected").val()];
      for (i = -tolerance[0]; i <= tolerance[1]; i++) {
        var tempDate=new Date(_date.getTime());
        tempDate.setDate(tempDate.getDate()+i);
        _dates.push(tempDate.getTime());
      }
    }
  })
  highlight_dates();
}
