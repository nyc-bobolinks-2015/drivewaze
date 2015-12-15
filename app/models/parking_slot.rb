class ParkingSlot < ActiveRecord::Base
	has_many :time_slots
	belongs_to :listing
end
