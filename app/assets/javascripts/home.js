$(document).ready(function() {
	reloadCalendar(0);
});

function reloadCalendar(items) {

		var startDate = new Date() / 1000 - 31556900;
		var endDate = new Date() / 1000 + 31556900;

		var events;
		
		var $calendar = $("#calendar");

		var calHeight = $(window).height() - $calendar.offset().top - $('footer').height();

		var params = {};

		if (items == 0) {
			params = {
				start_date : startDate,
				end_date : endDate
			}
		}
		else {
			params = {
				start_date : startDate,
				end_date : endDate,
				equip_ids : items
			}	
		}

		$calendar.fullCalendar('destroy');

		$calendar.fullCalendar({
			header : {
				left : 'prev,next today',
				center : 'title',
				right : 'month,basicWeek,basicDay'
			},
			defaultView: 'basicWeek',
			editable : false,
			eventSources : [{
				url : app_path + "/bookings/daterange",
				data : params
			}],
			eventClick : function(calEvent, jsEvent, view) {
				$modalContainer = $('#modalContainer');
				$modalContainer.foundation('reveal', 'open', {
					url: app_path + "/bookings/" + calEvent.id + "/edit",
					complete: function() {
						initializeComponents($modalContainer);
					}
				}); 
			},
			eventRender : function(event, jqElement, view){
				jqElement.find('.fc-event-title').html(event.title);
			},
			height: calHeight,
			weekMode: 'liquid',
			weekends:false,
			slotEventOverlap:false

		});
	}



