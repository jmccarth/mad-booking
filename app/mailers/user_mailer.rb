class UserMailer < ActionMailer::Base
  default from: Setting.find_by_key("email_from_address").value

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

  def sign_in_email(user,booking,eq_ids)
    @user = user
    @booking = booking
    @eq_ids = eq_ids
    email = user.username + "@uwaterloo.ca"
    mail(to:email, subject: 'Equipment Signed In at MAD Service Desk')
  end

end
