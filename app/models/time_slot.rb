class TimeSlot < ActiveRecord::Base
	has_one :parking_slots_time_slot
	has_one :parking_slot, through: :parking_slots_time_slot

  # Though it may seem obvious, it's worth being explicit 
  # by defining a named constant like 
  # DURATION = 2.hours
  # Then end is start_time + DURATION
  # Also, end is a reserved word - maybe end_time would be better
	def end
		self.start_time + 2.hours
	end
end