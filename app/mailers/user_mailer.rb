class UserMailer < ActionMailer::Base
  default from: "env-help@uwaterloo.ca"

  def booked_email(user,booking)
  	@user = user
  	@booking = booking
  	email = user.username + "@uwaterloo.ca"
  	mail(to:email, subject: 'Equipment Booking at MAD Service Desk')
  end

  def sign_out_email(user,booking,eq_ids)
  	@user = user
  	@booking = booking
  	@eq_ids = eq_ids
  	email = user.username + "@uwaterloo.ca"
  	mail(to:email, subject: 'Equipment Signed Out at MAD Service Desk')
  end

end
