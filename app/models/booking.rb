class Booking < ActiveRecord::Base
  include IceCube

  has_and_belongs_to_many :equipments

end
