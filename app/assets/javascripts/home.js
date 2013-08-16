$(document).ready(function() {

	var startDate = new Date() / 1000 - 31556900;
	var endDate = new Date() / 1000 + 31556900;

	var events;

	$('#calendar').fullCalendar({
		header : {
			left : 'prev,next today',
			center : 'title',
			right : 'month,agendaWeek,agendaDay'
		},
		editable : false,
		eventSources : [{
			url : "/bookings",
			data : {
				start_date : startDate,
				end_date : endDate
			}
		}],
		eventClick : function(calEvent, jsEvent, view) {
			window.open("bookings/" + calEvent.id + "/edit")
		},
		eventRender: function(calEvent,element){
			if (calEvent.status == 0){
				calEvent.color = "blue"
			}
			else{
				calEvent.color = "green"
			}
		}
	});
});

function reloadCalendar(items) {
	$('#calendar').fullCalendar('destroy');
	var startDate = new Date() / 1000 - 31556900;
	var endDate = new Date() / 1000 + 31556900;

	var events;

	$('#calendar').fullCalendar({
		header : {
			left : 'prev,next today',
			center : 'title',
			right : 'month,agendaWeek,agendaDay'
		},
		editable : true,
		eventSources : [{
			url : "/bookings",
			data : {
				start_date : startDate,
				end_date : endDate,
				equip_ids : items
			}
		}],
		eventClick : function(calEvent, jsEvent, view) {
			window.open("bookings/" + calEvent.id)
		}
	});
}

