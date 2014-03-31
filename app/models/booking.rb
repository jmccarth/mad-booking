class Booking < ActiveRecord::Base
  include IceCube
  include ActiveModel::Validations
  
  belongs_to :user
  has_many :events, :dependent => :destroy
  has_and_belongs_to_many :equipments
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
  validate :real_user
  validate :allowed_user
  validate :correct_times
  validate :has_no_conflicts
  validates_presence_of :equipments
  
  
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
    @equip_conflicts = Booking.find(:all, :include=>:equipments, :conditions=>['equipment.id in (?)',equip_ids])
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