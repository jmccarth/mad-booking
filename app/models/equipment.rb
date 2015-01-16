class Equipment < ActiveRecord::Base
  before_save :default_values
  has_and_belongs_to_many :bookings
  has_and_belongs_to_many :tags
  belongs_to :category
  validates_presence_of :name
  validates_uniqueness_of :barcode

  @@valid_statuses = [['In', 1], ['Out', 0], ['Out for Repair', 2]] #the way the items in the array of arrays is listed is the way it appears on the dropdown

  def default_values
    if self.status.nil?
      self.status = 1
    end
  end

  def tag_ids_stringlist
    tag_ids = []
    self.tags.each do |tag|
      tag_ids.push(tag.id)
    end
    tag_ids.join(" ")
  end

  # getter for the valid_statuses array
  def self.valid_statuses
    @@valid_statuses
  end

  #returns the status string by the status number
  def self.get_status(status_id)
    @@valid_statuses.each do |status|
      if status[1] == status_id
        return  status[0]
      end
    end

    return "Invalid Status"
  end

end
