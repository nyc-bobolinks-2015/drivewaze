class ParkingSlotsTimeSlot < ActiveRecord::Base
	belongs_to :parking_slot
	belongs_to :time_slot

  #avoid passing params directly to the model like this.
  # It's probably clearer to do
  # def self.for_time_period(start, end) so that it's obvious which params 
  # are of interest
	def self.current(params)
		parking_slot=ParkingSlot.find(params[:parking_slot_id])
		psts=parking_slot.time_slots.where("start_time >= ? AND start_time <= ?",DateTime.parse(params[:start]),DateTime.parse(params[:end]))
		return psts
	end
end
