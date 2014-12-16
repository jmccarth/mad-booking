#call this file in the rails console by
#    load "filename.rb"
#then simply call the below functions

def booking_converter
    all_bookings = Booking.all
    
    all_bookings.each do |booking|
        if(!booking.schedule.nil?)
            e = booking.events.build(:start=>booking.schedule[:start_date],:end=>booking.schedule[:end_time],:booking_id=>booking.id)
            e.save
            booking.update_attribute(:schedule,nil)
            booking.save
        end
    end
end


# converts existing categories into tags

def category_convert
	equipment_all = Equipment.all

	equipment_all.each do |equipment|
		category = equipment.category


		#create multiple tags if it has a colon 
		if category.name.include? ':'

			new_tags = category.name.split(':')

			new_tags.each do |tag_name|
				new_tag = Tag.find_by({ :name => tag_name })

				if new_tag == nil
					new_tag = Tag.create({ :name => tag_name })
				end

				equipment.tags.push(new_tag)				
			end
		else
			new_tag = Tag.find_by({ :name => category.name })

			if new_tag == nil
				new_tag = Tag.create({ :name => category.name })
			end

			equipment.tags.push(new_tag)
		end	


		equipment.save
		
	end	
end