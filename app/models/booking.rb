class Booking < ActiveRecord::Base
  include IceCube

  has_and_belongs_to_many :equipments
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
end
