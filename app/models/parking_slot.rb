class ParkingSlot < ActiveRecord::Base
	has_many :time_slots
	belongs_to :listing

  VEHICLE_CLASSES = {0 => "Compact", 1 => "Full Size", 2 => "SUV" }
  SLOT_TYPES = {0 => "Driveway", 1 => "Lawn Parking", 2 => "Street Side Parking", 3 => "Permit Parking"}
end
