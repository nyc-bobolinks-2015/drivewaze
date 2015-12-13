class TimeSlot < ActiveRecord::Base
	has_one :parking_slots_time_slot
	has_one :parking_slot, through: :parking_slots_time_slot

	def end
		self.start_time + 2.hours
	end
end