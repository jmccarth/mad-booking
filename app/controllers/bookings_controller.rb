include RubyCAS
include BookingsHelper
class BookingsController < ApplicationController

  helper :all
  helper_method :find_by_date_range

  before_filter RubyCAS::Filter do |controller|
      controller.valid_user()
  end
  #before_filter :format_schedule_write, :only => [:create,:update]

  layout :booking_layout

  def logout
    RubyCAS::Filter.logout(self,root_path)
  end

  def daterange
    sTime = Time.at(params[:start].to_i)
    eTime = Time.at(params[:end].to_i)
    @events = find_by_date_range(sTime,eTime)
    b = []
    if(params.has_key?(:equip_ids))
        #Filter all in date range by equipment ids
        found_ids = []
        #List of equipment being searched for
        equips = params[:equip_ids]
        equips = equips.map{|e| e.to_i}
        @events.each do |ev|
            #List of equipment ids for this event
            e_ids = ev.booking.equipment
            e_ids = e_ids.map{|e| e.id}
            if ((equips & e_ids).count > 0)
                b.push(convert_booking_to_fcevent(ev))
            end
        end
    else
      @events.each do |ev|
         b.push(convert_booking_to_fcevent(ev))
      end
    end

    respond_to do |format|
      format.json { render json: b }
    end
  end

  def column
    @bookings = Booking.pluck(request.params[:column])

    respond_to do |format|
      format.json { render json: @bookings }
    end
  end

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.json
  def create
    username = params[:booking].delete :user
    user = User.find_by_username(username)
    if (user.nil? and params[:create_if_new])
      User.create(:username => username)
      user = User.find_by_username(username)
    end

    @booking = Booking.new(booking_params)
    @booking.user = user


    #Schedule start and end dates and times
    #Dates ("07/29/2013")
    event_start_d = params[:schedule_start]
    event_end_d = params[:schedule_end]
    #Times ("01:00 PM")
    event_start_t = params[:schedule_start_time]
    event_end_t = params[:schedule_end_time]

    #Stitch together the strings and parse them
    event_start_dt = Time.strptime(event_start_d + event_start_t, "%m/%d/%Y%I:%M %p");
    event_end_dt = Time.strptime(event_end_d + event_end_t, "%m/%d/%Y%I:%M %p");

    @booking.schedule = build_recurrence(event_start_dt,event_end_dt)

    respond_to do |format|
      if @booking.save
        #Send an email to the user informing them of the details of the booking
        if Setting.find_by_key("email_on_booking").value == "true"
          UserMailer.booked_email(@booking.user,@booking).deliver
        end
        #Go back to main page
        format.html { redirect_to root_path, notice: 'Booking was successfully created.' }
        format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render action: "new" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    params[:booking][:equipment_ids] ||= []
    params[:booking][:sign_out_ids] ||= []
    params[:booking][:sign_in_ids] ||= []
    @booking = Booking.find(params[:id])

    username = params[:booking].delete :user
    user = User.find_by_username(username)
    if (user.nil? and params[:create_if_new])
      User.create(:username => username)
      user = User.find_by_username(username)
    end
    @booking.user = user

    #Grab ids of items being signed out and do some hash magic
    so_ids = params[:booking].delete :sign_out_ids
    out = {}
    so_ids.each do |so_id|
      if so_id != ""
        out[so_id.to_i] = DateTime.now
        Equipment.update(so_id.to_i, :status => 0)
      end
    end

    #Grab ids of items being signed in and do some hash magic
    si_ids = params[:booking].delete :sign_in_ids
    sign_in = {}
    si_ids.each do |si_id|
      if si_id != ""
        sign_in[si_id.to_i] = DateTime.now
        Equipment.update(si_id.to_i, :status => 1)
      end
    end

    b = Booking.find(params[:id])

    #Get any existing sign out times from event object
    sot = b.sign_out_times
    #Merge those sign out times with new values from out_times hash we created
    sot.merge!(out)
    #Merge those results into params hash
    out_times = {:sign_out_times=>sot}
    params[:booking].merge!(out_times)

    #Get any existing sign in times from event object
    sit = b.sign_in_times
    #Merge those sign in times with new values from in_times hash we created
    sit.merge!(sign_in)
    #Merge those results into params hash
    in_times = {:sign_in_times=>sit}
    params[:booking].merge!(in_times)


    #Schedule start and end dates and times
    #Dates ("07/29/2013")
    event_start_d = params[:schedule_start]
    event_end_d = params[:schedule_end]
    #Times ("01:00 PM")
    event_start_t = params[:schedule_start_time]
    event_end_t = params[:schedule_end_time]

    #Stitch together the strings and parse them
    event_start_dt = Time.strptime(event_start_d + event_start_t, "%m/%d/%Y%I:%M %p");
    event_end_dt = Time.strptime(event_end_d + event_end_t, "%m/%d/%Y%I:%M %p");
	
    @booking.events.first.update(:start=>event_start_dt,:end=>event_end_dt)

    @booking.schedule = build_recurrence(event_start_dt,event_end_dt)

    respond_to do |format|
      if @booking.update_attributes(booking_params)
        if so_ids != []
          if Setting.find_by_key("email_on_sign_out").value == "true"
            UserMailer.sign_out_email(@booking.user,@booking,so_ids).deliver
          end
        end

        if si_ids != []
          if Setting.find_by_key("email_on_sign_in").value == "true"
            UserMailer.sign_in_email(@booking.user,@booking,si_ids).deliver
          end
        end
        format.html { redirect_to root_path, notice: 'Booking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    if @booking.sign_out_times.length == 0
      @booking.destroy
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

private

  def booking_layout
    params[:action] == 'edit' || params[:action] == 'new' ? false : 'application'
  end

  def booking_params
    params.require(:booking).permit!
  end

  def check_user_exists
    uname = params[:booking][:user]
    if User.where(username: uname).length == 0
      respond_to do |format|
        format.html { flash[:notice] = "User does not exist: " + uname
          render action: "new" }
      end
    end
  end

  def build_recurrence(event_start_dt,event_end_dt)
    weekly_rep = params[:weekly_repeat]
    num_weeks = params[:num_weeks]
    @booking.events.delete_all
	
    if weekly_rep == "1"
      #TODO: This probably isn't smart, but it'll work for now
      #This will be a problem for history tracking

      r = Recurrence.new(:every => :week, :on => event_start_dt.strftime("%A").parameterize.underscore.to_sym, :repeat => num_weeks.to_i, :starts => event_start_dt.to_date)

      #r = Recurrence.new(:every => :week, :on => :friday, :repeat => 4)
      r.events.each{ |date|
        new_start = Time.new(date.year, date.month, date.day, event_start_dt.hour, event_start_dt.min, event_start_dt.sec, event_start_dt.utc_offset)
        new_end = new_start + (event_end_dt - event_start_dt)
        @booking.events.build(:start=>new_start,:end=>new_end)
      }
    else
      #a single event, no recurrence pattern specified
      @booking.events.build(:start=>event_start_dt,:end=>event_end_dt)
      r = nil
    end
    r
  end
end
