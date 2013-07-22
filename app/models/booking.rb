class Booking < ActiveRecord::Base
  include IceCube
  
=begin
  def schedule=(new_schedule)
    write_attribute(:schedule,new_schedule.to_yaml())
  end
  
  def schedule
    Schedule.from_yaml(read_attribute(:schedule))
  end
=end
end
