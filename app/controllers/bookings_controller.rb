include RubyCAS
include BookingsHelper
class BookingsController < ApplicationController

  helper :all
  helper_method :find_by_date_range
  layout false
  before_filter RubyCAS::Filter do |controller|
      controller.valid_user()
  end
  #before_filter :format_schedule_write, :only => [:create,:update]
  
  def logout
    RubyCAS::Filter.logout(self,root_path)
  end

  def daterange
    sTime = Time.at(params[:start_date].to_i)
    eTime = Time.at(params[:end_date].to_i)
    @bookings = find_by_date_range(sTime,eTime)
    b = []

    if(params.has_key?(:equip_ids))
      found_ids = []
      equips = params[:equip_ids]
      @bookings.each do |booking|
        for equip in equips do
          if booking.equipments.include?(Equipment.find(equip))
            if !found_ids.include?(booking.id)
              b.push(convert_booking_to_fcevent(booking))  
              found_ids.push(booking.id)
            end
          end    
        end
      end
    else
      @bookings.each do |booking|
         b.push(convert_booking_to_fcevent(booking))
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
    @booking.events.build(:start=>event_start_dt,:end=>event_end_dt)    
    
    respond_to do |format|
      if @booking.save
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

    respond_to do |format|
      if @booking.update_attributes(booking_params)
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

  
end