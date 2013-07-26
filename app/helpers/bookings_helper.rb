module BookingsHelper
  
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
  
    event = {
      title: booking.user,
      start: startDate,
      end: endDate
    }
    
  end

end
