class Booking < ActiveRecord::Base
  include IceCube
  include ActiveModel::Validations
  
  belongs_to :user
  has_many :events, :dependent => :destroy
  has_and_belongs_to_many :equipment
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
  serialize :schedule
  validate :real_user
  validate :allowed_user
  validate :correct_times
  validate :has_no_conflicts
  validates_presence_of :equipment

  #Function to determine the status of a piece of a equipment attached to the booking
  def get_item_status(item_id)
	status = ""
	overdue = true
	# Is the booking recurring?
	if self.schedule.nil?
		# Not recurring
		
		# Is item in signed out list?
		
		if self.sign_out_times.key?(item_id)
			# Item signed out. 
			if self.sign_in_times.key?(item_id)
				#If it is also signed in, it is "In"
				status = "In"
			else
				# If it is not signed in, it is "Out" or "Overdue" depending on time
				self.events.each do |ev|
					if (ev.start <= Time.now) & (ev.end >= Time.now)
						#Item is out for a current event, so status is "Out" not "Overdue"
						overdue = false
					end
					#If item is not found to be out for a current event it will be "Overdue"
				end
				if overdue
					status = "Overdue"
				else
					status = "Out"
				end
			end
		else
			# Item not signed out, it is "Booked"
			status = "Booked"
		end
	else
		# Recurring
		
		# Is item in signed out list?
		if self.sign_out_times.key?(item_id)
			#Item signed out
			if self.sign_in_times.key?(item_id)
				#Item is signed in
				if self.sign_out_times[item_id] >= self.sign_in_times[item_id]
					#Item is signed in and out, but the out time is after the in time
					#This means that the "In" was from a previous event in the recurrence, while the
					#"Out" is from a more recent event. Therefore the "Out"/"Overdue" takes precedence.
					# If it is not signed in, it is "Out" or "Overdue" depending on time
					self.events.each do |ev|
						if (ev.start <= Time.now) & (ev.end >= Time.now)
							#Item is out for a current event, so status is "Out" not "Overdue"
							overdue = false
						end
						#If item is not found to be out for a current event it will be "Overdue"
					end
					if overdue
						status = "Overdue"
					else
						status = "Out"
					end
				else
					if self.events.last.end <= Time.now
						#End of last event has passed (is before Now), item is permanently "In"
						status = "In"
					else
						#End of last event has not passed (so there are events in the future), item is "Booked"
						status = "Booked"
					end
				end
			else
				# If it is not signed in, it is "Out" or "Overdue" depending on time
				self.events.each do |ev|
					if (ev.start <= Time.now) & (ev.end >= Time.now)
						#Item is out for a current event, so status is "Out" not "Overdue"
						overdue = false
					end
					#If item is not found to be out for a current event it will be "Overdue"
				end
				if overdue
					status = "Overdue"
				else
					status = "Out"
				end
			end
		else
			#Item not signed out
			status = "Booked"
		end
	end
	status
  end
  
  private
  def real_user
    #Check to see if the user already exists. If not fail the validation.
    valid = User.exists?(self.user_id)
    self.errors.add(:user, "doesn't exist. Please create the user first.") unless valid
  end
  
  def allowed_user
    #Check to see that the user is allowed to book equipment.
    #status = 0 - user is in good standing
    #status = 1 - user is greylisted
    #status = 2 - user is blacklisted
    
    if !self.user_id.nil?
      status = User.find(self.user_id).status
    else
      self.errors.add(:user, "does not exist.")
    end
    
    if status == 2
      self.errors.add(:user, "has been blacklisted and is not allowed to book equipment.")
    elsif status == 1
      self.errors.add(:user, "has been greylisted and is not allowed to book equipment.")
    end
  end
  
  
  
  def correct_times
    #Check to see that the times for the booking are sensible
    
    #Is the start date/time before the end date/time?
    @e = self.events.first
    valid = @e.start < @e.end
    self.errors.add(:booking, "cannot be saved: Start time must come before end time") unless valid
  end
  
  def has_no_conflicts
    conflicts = false
    conflict_ids=[]
    #given an array of equipment ids, check to see if there are conflicting events
    equip_ids = self.equipment_ids
    @equip_conflicts = Booking.find(:all, :include=>:equipment, :conditions=>['equipment.id in (?)',equip_ids])
    @equip_conflicts.each do |booking_test|
      @e = booking_test.events.first
      @e1 = self.events.first
      if @e.nil? == false and @e1.nil? == false
        #Still using icecube gem to find conflicts
        s = IceCube::Schedule.new(start = @e.start, :end_time => @e.end)
        s1 = IceCube::Schedule.new(start = @e1.start, :end_time => @e1.end)
       
        if s.conflicts_with?(s1) and booking_test.id != self.id
		
          equip_ids.each do |eid|
            if !booking_test.sign_in_times.has_key?(eid) and booking_test.equipment_ids.include?(eid)
              conflicts = true
              conflict_ids.push(booking_test.id)
			elsif booking_test.sign_in_times.has_key?(eid) and booking_test.equipment_ids.include?(eid)
				if @e.start > Time.now
					conflicts = true
					conflict_ids.push(booking_test.id)
				end
            end
          end
        end
      end
    end
    valid = conflict_ids.length == 0
    notice_link = "conflicts with bookings "
    for cb in conflict_ids do
      notice_link += "#" + cb.to_s + ","
    end
    self.errors.add(:booking, notice_link) unless valid
  end
end