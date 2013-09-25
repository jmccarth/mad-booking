class User < ActiveRecord::Base
  before_save :default_values
  has_many :bookings
  accepts_nested_attributes_for :bookings
  validates :username, :uniqueness => true
  validates :username, :presence => true
  
  def default_values
    if self.admin.nil?
      self.admin = false
    end
    self.status ||= 0
  end
end
