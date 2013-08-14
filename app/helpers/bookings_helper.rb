module BookingsHelper
  
  def has_conflict(booking,equip_ids)
    conflicts = false
    conflict_ids=[]
    #given an array of equipment ids, check to see if there are conflicting events
    @equip_conflicts = Booking.find(:all, :include=>:equipments, :conditions=>['equipment.id in (?)',equip_ids])
    @equip_conflicts.each do |booking_test|
      s = IceCube::Schedule.from_yaml(booking_test.schedule)
      s1 = IceCube::Schedule.from_yaml(booking.schedule)
      if s.conflicts_with?(s1) and booking_test.id != booking.id
        conflicts = true
        conflict_ids.push(booking_test.id)
      end
    end
    conflict_ids
  end
  
  def find_by_date_range(start_date,end_date)
    @all_bookings = Booking.all
    range_bookings = []
    @all_bookings.each do |booking|
      ev_sched = IceCube::Schedule.from_yaml(booking.schedule)
      if ev_sched.occurs_between?(start_date,end_date)
        range_bookings.push(booking)
      end
    end
    range_bookings
  end
  
  def convert_booking_to_fcevent(booking)
    booking_sched = IceCube::Schedule.from_yaml(booking.schedule)
    startDate = booking_sched.start_time
    endDate = booking_sched.end_time
    
    startD = Date.parse(startDate.to_s)
    endD = Date.parse(endDate.to_s)
  
    #All day event?
    if startD === endD
      isAllDay = false
    else
      isAllDay = true
    end
  
    #Booking title
    user = booking.user.username
    equip_list = "["
    for e in booking.equipments do
      equip_list += e.name + ","
    end
    equip_list = equip_list[0,equip_list.length - 1]
    equip_list += "]"
    b_title = user + " " + equip_list
  
    #Equipment status
    if booking.equipments.count == booking.sign_in_times.count
      #Everything is signed in, booking is done
      b_status = 2
      b_color = "green"
    elsif booking.sign_out_times.count > 0
      #At least 1 item is signed out, booking is active
      b_status = 1
      b_color = "blue"
    else
      #Nothing signed out, booking is pending
      b_status = 0
      b_color = "purple"
    end
  
    event = {
      title: b_title,
      start: startDate,
      end: endDate,
      id: booking.id,
      allDay: isAllDay,
      status: b_status,
      color: b_color
    }
    
  end

end
