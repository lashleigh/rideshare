function available(a){return dmy=a.getDate()+"-"+(a.getMonth()+1)+"-"+a.getFullYear(),$.inArray(dmy,availableDates)==-1?[!1,"","Unavailable"]:$.inArray(a.getTime(),_dates)>=0?[!0,"highlighted-week","Week Range"]:[!0,""]}function highlight_dates(){$(".ui-state-default").parent().removeClass("highlighted-week");var a=$(".ui-state-default").index($(".ui-state-active")),b=flexibility[$("#start_flexibility :selected").val()];for(i=-b[0];i<=b[1];i++)$($(".ui-state-default")[a+i]).parent().addClass("highlighted-week")}function parse_date(a){var b=availableDates[a].split("-");return new Date(b[2],b[1]-1,b[0])}function handle_datepicker(){$("#start_flexibility").change(highlight_dates),$("#start_date").datepicker({altField:"#alternate",altFormat:"yy-mm-d",minDate:parse_date(0),maxDate:parse_date(availableDates.length-1),beforeShowDay:available,onSelect:function(a){var b=new Date(a);_dates=[];var c=flexibility[$("#start_flexibility :selected").val()];for(i=-c[0];i<=c[1];i++){var d=new Date(b.getTime());d.setDate(d.getDate()+i),_dates.push(d.getTime())}}}),highlight_dates()}var _dates=[]