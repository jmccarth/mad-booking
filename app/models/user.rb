class User < ActiveRecord::Base
  before_save :default_values
  has_many :bookings
  accepts_nested_attributes_for :bookings
  validates :username, :uniqueness => true
  validates :username, :presence => true

  @@valid_statuses = [['Good Standing', 0], ['Warned', 1], ['Blacklisted', 2]]

  def default_values
    if self.admin.nil?
      self.admin = false
    end
    self.status ||= 0
  end

  # getter for the valid_statuses array
  def self.valid_statuses
    @@valid_statuses
  end

  #returns the status string by the status number
  def self.get_status(status_id)
    @@valid_statuses.each do |status|
      if status[1] == status_id
        return  status[0]
      end
    end

    return "Invalid Status"
  end
end
