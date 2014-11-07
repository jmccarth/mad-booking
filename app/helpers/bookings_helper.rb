module BookingsHelper
  
  def find_by_date_range(start_date,end_date)
    
    # Retrieve all events that do not start after end_date 
    # and do not end before start_date
    range_events = Event.where("start <= ? AND end >= ?", end_date, start_date)
    range_events
  end
  
  def find_active_by_date_range(start_date,end_date)
    # Retrieve all events that do not start after end_date 
    # and do not end before start_date
    range_events = Event.where("start <= ? AND end >= ?", end_date, start_date)
    range_events_return = []
    for re in range_events do
        if re.booking.sign_out_times.count > re.booking.sign_in_times.count
          range_events_return.push(re)
        end
    end
    range_events_return
  end

	def convert_booking_to_fcevent(event)
    
		ev_booking = event.booking
		evb_user = ev_booking.user
		evb_equip = ev_booking.equipment
		evb_sit = ev_booking.sign_in_times
		evb_sot = ev_booking.sign_out_times
		startDate = event.start
		endDate = event.end

		eventStartStr = event.start.to_i
		eventEndStr = event.end.to_i
		  
		#All day event?
		if startDate.to_date === endDate.to_date
			isAllDay = false
		else
			isAllDay = true
		end
		
		#Booking title
		if evb_user.nil?
			user = "UNKNOWN USER"
		else
			user = evb_user.username
		end
		
		equip_list = "<ul>"
		if evb_equip.count <= 5
			for e in evb_equip do
				equip_list += "<li>" + e.name + "</li>"
			end
		else
			for e in evb_equip[0..3] do
				equip_list += "<li>" + e.name + "</li>"
			end
			equip_list += "<li>& " + (evb_equip.count - 4).to_s + " more items</li>"        
		end

		#equip_list = equip_list[0,equip_list.length - 1]
		equip_list += "</ul>"
		b_title = "<a class='username' href='#'>" + user + "</a> <div class='list'>" + equip_list + "</div>"
    
		b_status = 0
		b_color = "#9933cc"
		num_items_in = 0
	
		# Equipment status
		for e in evb_equip do
			#Pending = 0
			#Active = 1
			#Done = 2
			#Overdue = 3
			
			item_status = ev_booking.get_item_status(e.id)
			if item_status == "Out"
				#If at least 1 item is "Out" the booking is active
				b_status = 1
				b_color = "#3366ff"
			elsif item_status == "Overdue"
				#If at least 1 item is "Overdue" the booking is active
				b_status = 3
				b_color = "#dd0000"
			elsif item_status == "In"
				num_items_in = num_items_in + 1
			end
		end
		
		#If b_status is still 0, then all items are "In" or "Booked"
		#If number of items In matches number of items in the booking, it is finished if non-recurring
		#Or if it is recurring and the last event has ended
		if (num_items_in == evb_equip.count) && (ev_booking.schedule.nil? || ev_booking.events.last.end <= Time.now)
			b_status = 2
			b_color = "#00aa22"
		end
		

		event = {
			title: b_title,
			start: eventStartStr,
			end: eventEndStr,
			id: ev_booking.id,
			#id: event.id,
			allDay: isAllDay,
			status: b_status,
			color: b_color,
			equip: evb_equip
		}
		
	end

  def get_overdue_items()

    #get all events with an end date before right now
    @events_before_now = Event.where("end <= ?", Time.now)
    overdue_events = []
    @events_before_now.each do |event|
      if event.end < Time.now and event.booking.sign_in_times.count < event.booking.sign_out_times.count
        overdue_events.push(event)
      end
    end

    overdue_events
  end
  

end