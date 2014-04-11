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
      evb_equip = ev_booking.equipments
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
    
      #Equipment status
      if evb_equip.count == evb_sit.count
        #Everything is signed in, booking is done
        b_status = 2
        b_color = "#00aa22"
      elsif evb_sot.count > 0
        #At least 1 item is signed out, booking is active
        if endDate < Time.now and evb_sot.count > evb_sit.count
          #Booking is overdue
          b_status = 3
          b_color = "#dd0000"
        else
          #Booking is active
          b_status = 1
          b_color = "#3366ff"
        end
      else
        #Nothing signed out, booking is pending
        b_status = 0
        b_color = "#9933cc"
      end

      event = {
        title: b_title,
        start: eventStartStr,
        end: eventEndStr,
        id: ev_booking.id,
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