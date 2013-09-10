$(document).ready(function() {

	var startDate = new Date() / 1000 - 31556900;
	var endDate = new Date() / 1000 + 31556900;

	var events;
	
	var $calendar = $("#calendar");

	var calHeight = $(window).height() - $calendar.offset().top - $('footer').height();

	$calendar.fullCalendar({
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
			$modalContainer = $('#modalContainer');
			$modalContainer.foundation('reveal', 'open', {
				url: "/bookings/" + calEvent.id + "/edit",
				complete: function() {
					initializeComponents($modalContainer);
				}
			}); 
		},
		eventRender : function(event, jqElement, view){
			if (view.name == 'month'){
				jqElement.height(15);
			}
		},
		height: calHeight,
		weekMode: 'liquid'

	});
});

function reloadCalendar(items) {
	var startDate = new Date() / 1000 - 31556900;
	var endDate = new Date() / 1000 + 31556900;

	var $calendar = $("#calendar");

	var calHeight = $(window).height() - $calendar.offset().top - $('footer').height();

	$calendar.fullCalendar('destroy');

	var events;

	$calendar.fullCalendar({
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
			$modalContainer = $('#modalContainer');
			$modalContainer.foundation('reveal', 'open', {
				url: "/bookings/" + calEvent.id + "/edit",
				complete: function() {
					initializeComponents($modalContainer);
				}
			}); 
		},
		eventRender : function(event, jqElement, view){
			if (view.name == 'month'){
				jqElement.height(15);
			}
		},
		height: calHeight,
		weekMode: 'liquid'
	});
}
