class Booking < ActiveRecord::Base
  include IceCube
  include ActiveModel::Validations
  
  #validates_with BookingsValidator
  belongs_to :user
  has_and_belongs_to_many :equipments
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
end
