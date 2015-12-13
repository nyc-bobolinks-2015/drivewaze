class ParkingSlot < ActiveRecord::Base
	has_many :parking_slots_time_slots
	has_many :time_slots, through: :parking_slots_time_slots
	belongs_to :listing
end
