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
		editable : true,
		eventSources : [{
			url : "/bookings",
			data : {
				start_date : startDate,
				end_date : endDate
			}
		}],
		eventClick : function(calEvent, jsEvent, view) {
			window.open("bookings/" + calEvent.id)
		}
	});

	var chars = [];
	var barcode = "";
	$(window).keypress(function(e) {
		barcode += String.fromCharCode(e.which);
		if(e.which === 13){
			$("#barcode_" + barcode)[0].checked = !$("#barcode_" + barcode)[0].checked;
			barcode = "";
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

