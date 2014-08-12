class ApplicationController < ActionController::Base
  protect_from_forgery

  	def valid_user()
    	unless User.where(username: session[:cas_user], admin: true).length > 0
    		flash[:notice] = "User " + session[:cas_user] + " does not have permission to use the booking system."
    		redirect_to ('/invaliduser')
    	end
  	end

    def check_settings()
      key_notice = ""
      val_notice = ""

      if Setting.find_by_key("email_on_booking").nil?
        key_notice += "<li>email_on_booking</li>"
      else
        if Setting.find_by_key("email_on_booking").value.nil? || Setting.find_by_key("email_on_booking").value.empty?
          val_notice += "<li>email_on_booking</li>"
        end
      end

      if Setting.find_by_key("email_on_sign_out").nil?
        key_notice += "<li>email_on_sign_out</li>"
      else
        if Setting.find_by_key("email_on_sign_out").value.nil? || Setting.find_by_key("email_on_sign_out").value.empty?
          val_notice += "<li>email_on_sign_out</li>"
        end
      end

      if Setting.find_by_key("email_on_sign_in").nil?
        key_notice += "<li>email_on_sign_in</li>"
      else
        if Setting.find_by_key("email_on_sign_in").value.nil? || Setting.find_by_key("email_on_sign_in").value.empty?
          val_notice += "<li>email_on_sign_in</li>"
        end
      end

      if Setting.find_by_key("site_name").nil?
        key_notice += "<li>site_name</li>"
      else
        if Setting.find_by_key("site_name").value.nil? || Setting.find_by_key("site_name").value.empty?
          val_notice += "<li>site_name</li>"
        end
      end

      if Setting.find_by_key("email_from_address").nil?
        key_notice += "<li>email_from_address</li>"
      else
        if Setting.find_by_key("email_from_address").value.nil? || Setting.find_by_key("email_from_address").value.empty?
          val_notice += "<li>email_from_address</li>"
        end
      end

      if key_notice != ""
		message = "The following settings are missing. You must fix this before using the application: <ul>" + key_notice + "</ul>"
        flash[:alert] = message.html_safe
		
      end

      if val_notice != ""
		message = "The following settings are missing values. You must fix this before using the application: <ul>" + val_notice + "</ul>"
        flash[:alert] = message.html_safe
      end

      if key_notice != "" || val_notice != ""
        redirect_to(settings_path)
      end

    end
end
