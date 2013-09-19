class ApplicationController < ActionController::Base
  protect_from_forgery

  	def valid_user()
    	unless User.where(username: session[:cas_user], admin: true).length > 0
    		flash[:notice] = "User " + session[:cas_user] + " does not have permission to use the booking system."
    		redirect_to ('/invaliduser')
    	end
  	end
end
