class Equipment < ActiveRecord::Base
  before_save :default_values
  has_and_belongs_to_many :bookings
  belongs_to :category
  validates_presence_of :name
  validates_uniqueness_of :barcode
  
  def default_values
    if self.status.nil?
      self.status = 1
    end
  end
end
