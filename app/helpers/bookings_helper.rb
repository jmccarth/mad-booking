module BookingsHelper
  
  def find_by_date_range(start_date,end_date)
    
    # Retrieve all events that do not start after end_date 
    # and do not end before start_date
    range_bookings = Event.where("start <= ? AND end >= ?", end_date, start_date)
    range_bookings
  end
  
  def convert_booking_to_fcevent(event)
    
      startDate = event.start
      endDate = event.end
      
      startD = Date.parse(startDate.to_s)
      endD = Date.parse(endDate.to_s)

      eventStartStr = event.start.to_i
      eventEndStr = event.end.to_i
      
      #All day event?
      if startD === endD
        isAllDay = false
      else
        isAllDay = true
      end
    
      #Booking title
      
      if event.booking.user.nil?
        user = "UNKNOWN USER"
      else
        user = event.booking.user.username
      end
      equip_list = "<ul>"
      if event.booking.equipments.count <= 5
        for e in event.booking.equipments do
          equip_list += "<li>" + e.name + "</li>"
        end
      else
        for e in event.booking.equipments[0..3] do
          equip_list += "<li>" + e.name + "</li>"
        end
        equip_list += "<li>& " + (event.booking.equipments.count - 4).to_s + " more items</li>"        
      end



      #equip_list = equip_list[0,equip_list.length - 1]
      equip_list += "</ul>"
      b_title = "<a class='username' href='#'>" + user + "</a> <div class='list'>" + equip_list + "</div>"
    
      #Equipment status
      if event.booking.equipments.count == event.booking.sign_in_times.count
        #Everything is signed in, booking is done
        b_status = 2
        b_color = "#00aa22"
      elsif event.booking.sign_out_times.count > 0
        #At least 1 item is signed out, booking is active
        if endDate < Time.now and event.booking.sign_out_times.count > event.booking.sign_in_times.count
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
        id: event.booking.id,
        allDay: isAllDay,
        status: b_status,
        color: b_color,
        equip: event.booking.equipments
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