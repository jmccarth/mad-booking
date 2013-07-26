$(document).ready(function() {
	
		var startDate = new Date()/1000-31556900;
		var endDate = new Date()/1000+31556900;
		
		var events;
		
		

		
		$('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			editable: true,
			eventSources: [{
				url: "/bookings",
				data:{
					start_date: startDate,
					end_date: endDate
				}			
			}]
		});
	});