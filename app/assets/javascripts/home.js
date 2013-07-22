$(document).ready(function() {
	
		var date = new Date();
		var d = date.getDate();
		var m = date.getMonth();
		var y = date.getFullYear();
		
		$('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			editable: true,
			events:function(start,end,callback){
				//TODO: Go into DB and get events for this time range
				bookings = [{title:"An event",start: new Date(y,m,d),end: new Date(y,m,d+1)},
							{title:"Another event",start: new Date(y,m,d+2,8,30),end: new Date(y,m,d+2,11,45),allDay: false}];
				callback(bookings);
			}
		});
		
	});