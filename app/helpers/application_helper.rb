module ApplicationHelper
	def report_errors(object)

		content_tag :div, class:"alert-box alert" do
			#content_tag(:p, "#{pluralize(object.errors.count, 'error')} prevented this #{object.class.name.downcase} from being saved.")
			content_tag :ul do
	    		object.errors.full_messages.collect { |error| concat(content_tag(:li, error)) }
	    	end
		end
	    
	end
end
