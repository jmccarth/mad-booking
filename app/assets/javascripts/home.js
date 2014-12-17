$(document).ready(function() {
	reloadCalendar(0);
});

function reloadCalendar(items) {

		var startDate = new Date() / 1000 - 31556900;
		var endDate = new Date() / 1000 + 31556900;

		var events;
		
		var $calendar = $("#calendar");
		var $calendarLoading = $("#calendar-loading");

		//var calHeight = $(window).height() - $calendar.offset().top - $('footer').height() - $("#legend").height() - 50;
		var calHeight = 1000;

		var params = {};

		if (items != 0) {
			params = {
                equip_ids : items
			}
		}
		

		$calendar.fullCalendar('destroy');

		$calendar.fullCalendar({
			defaultView: 'basicWeek',
			editable : false,
			eventClick : function(calEvent, jsEvent, view) {
				$modalContainer = $('#modalContainer');
				$modalContainer.foundation('reveal', 'open', {
					url: "bookings/" + calEvent.id + "/edit",
					complete: function() {
						initializeComponents($modalContainer);
					}
				}); 
			},
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
			height: calHeight,
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



