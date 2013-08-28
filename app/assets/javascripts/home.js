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
		defaultView: 'agendaWeek',
		editable : false,
		eventSources : [{
			url : "/bookings",
			data : {
				start_date : startDate,
				end_date : endDate
			}
		}],
		eventClick : function(calEvent, jsEvent, view) {
			$('#modalContainer').foundation('reveal', 'open', {
				url: "bookings/" + calEvent.id + "/edit"
			}); 
		},
		eventRender : function(event, jqElement, view){
			if (view.name == 'month'){
				jqElement.height(15);
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
		defaultView: 'agendaWeek',
		editable : false,
		eventSources : [{
			url : "/bookings",
			data : {
				start_date : startDate,
				end_date : endDate,
				equip_ids : items
			}
		}],
		eventClick : function(calEvent, jsEvent, view) {
			$('#modalContainer').foundation('reveal', 'open', {
				url: "bookings/" + calEvent.id + "/edit"
			}); 
		},
		eventRender : function(event, jqElement, view){
			if (view.name == 'month'){
				jqElement.height(15);
			}
		}
	});
}
