class Booking < ActiveRecord::Base
  include IceCube
  include ActiveModel::Validations
  
  #validates_with BookingsValidator
  belongs_to :user
  has_and_belongs_to_many :equipments
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
  validate :real_user
  validate :correct_times
  
  private
  def real_user
    #Check to see if the user already exists. If not fail the validation.
    valid = User.exists?(self.user_id)
    self.errors.add(:user, "doesn't exist. Please create the user first.") unless valid
  end
  
  def correct_times
    #Check to see that the times for the booking are sensible
    
    #Is the start date/time before the end date/time?
    
    schedule = IceCube::Schedule.from_yaml(self.schedule)
    valid = schedule.start_time < schedule.end_time 
    self.errors.add(:booking, "cannot be saved: Start time must come before end time") unless valid
  end
end
