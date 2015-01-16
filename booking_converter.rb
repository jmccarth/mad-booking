def booking_converter
    all_bookings = Booking.all
    
    all_bookings.each do |booking|
        if(!booking.schedule.nil?)
            e = booking.events.build(:start=>booking.schedule[:start_date],:end=>booking.schedule[:end_time],:booking_id=>booking.id)
            e.save
            booking.update_attribute(:schedule,nil)
            booking.save
        end
    end
end