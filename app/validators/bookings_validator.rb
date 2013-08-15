class BookingsValidator < ActiveModel::Validator
  def validate(record)
    debugger
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
end