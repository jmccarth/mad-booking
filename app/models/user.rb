class User < ActiveRecord::Base
  before_save :default_values
  has_many :bookings
  
  def default_values
    if self.admin.nil?
      self.admin = false
    end
    self.status ||= 0
  end
end
