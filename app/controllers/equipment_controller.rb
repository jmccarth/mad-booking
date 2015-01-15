class EquipmentController < ApplicationController

  before_filter RubyCAS::Filter do |controller|
      controller.valid_user()
  end

  # GET /equipment
  # GET /equipment.json
  def column
    @equipment = Equipment.pluck(request.params[:column])

    respond_to do |format|
      format.json { render json: @equipment }
    end
  end

  def tags
    @equipment = Equipment.joins(:tags).where(tags:{name: request.params[:tag_name]})

    respond_to do |format|
      format.json { render json: @equipment }
    end
  end

  # GET /equipment.json
  def index
    @equipment = Equipment.all

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @equipment }
      format.json { render json: @equipment.to_json(:include => :tags) }
    end
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
    @equipment = Equipment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @equipment }
    end
  end

  # GET /equipment/new
  # GET /equipment/new.json
  def new
    @equipment = Equipment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @equipment }
    end
  end

  # GET /equipment/1/edit
  def edit
    @equipment = Equipment.find(params[:id])
  end

  # POST /equipment
  # POST /equipment.json
  def create
    #tags are sent to the controller as a string array
    #we'll create our own way to find the Tag objects
    tags = equipment_params[:tags]

    tags_object_collection = []

    tags.each do |tag|
      if tag == ''
        next
      end

      tag_obj = Tag.find(tag)

      if tag_obj != nil
        tags_object_collection.push(tag_obj)
      end
    end

    new_equipment_params = equipment_params.except(:tags)

    @equipment = Equipment.new(new_equipment_params)
    @equipment.tags = tags_object_collection

    respond_to do |format|
      if @equipment.save
        format.html { redirect_to equipment_index_path, notice: 'Equipment was successfully created.' }
        format.json { render json: @equipment, status: :created, location: @equipment }
      else
        format.html { render action: "new" }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /equipment/1
  # PUT /equipment/1.json
  def update
    tags = equipment_params[:tags]

    tags_object_collection = []

    tags.each do |tag|
      if tag == ''
        next
      end

      tag_obj = Tag.find(tag)

      if tag_obj != nil
        tags_object_collection.push(tag_obj)
      end
    end

    new_equipment_params = equipment_params.except(:tags)

    @equipment = Equipment.find(params[:id])
    @equipment.tags = tags_object_collection

    respond_to do |format|
      if @equipment.update_attributes(new_equipment_params)
        format.html { redirect_to equipment_index_path, notice: 'Equipment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy

    respond_to do |format|
      format.html { redirect_to equipment_index_url }
      format.json { head :no_content }
    end
  end

  private

  def equipment_params
    params.require(:equipment).permit(:name,:barcode,:category_id,:stored,:contents,:serial_number,:status,:tags => [])
  end
end
