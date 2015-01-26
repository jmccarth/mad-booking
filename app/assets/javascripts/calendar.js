
$(document).ready(function (){
  reloadCalendar();
});

/*

function reloadCalendar(){
  var $calendar = $("#calendar");
  var $calendarLoading = $("#calendar-loading");

  params = {};

  $calendar.fullCalendar({
    defaultView: 'basicWeek',
    editable : false,
    //eventClick : function(calEvent, jsEvent, view) {},
    eventRender : function(event, jqElement, view){
      jqElement.find('.fc-event-title').html(event.title);
    },
    eventSources : [{
      url : "bookings/daterange",
      data : params
    }],
    header : {
      left : 'prev,next today',
      center : 'title',
      right : 'month,basicWeek,basicDay'
    },
    height: 750,
    loading : function(isLoading) {
      if (isLoading) $calendarLoading.css('opacity', '1');
      else $calendarLoading.css('opacity', '0');
    },
    maxTime:19,
    minTime:7,
    slotEventOverlap:false,
    timeFormat: 'h(:mm)t{ - h(:mm)t',
    weekends:false,
    weekMode: 'liquid'
  });
}
*/