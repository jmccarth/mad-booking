class Booking < ActiveRecord::Base
  include IceCube
  include ActiveModel::Validations
  
  #validates_with BookingsValidator
  belongs_to :user
  has_and_belongs_to_many :equipments
  serialize :sign_in_times, Hash
  serialize :sign_out_times, Hash
  validate :real_user
  
  private
  def real_user
    #Check to see if the user already exists. If not fail the validation.
    valid = User.exists?(self.user_id)
    self.errors.add(:user, "doesn't exist. Please create the user first.") unless valid
  end
end
