class ParkingSlotsTimeSlot < ActiveRecord::Base
	belongs_to :parking_slot
	belongs_to :time_slot

	def self.current(params)
		parking_slot=ParkingSlot.find(params[:parking_slot_id])
		psts=parking_slot.time_slots.where("start_time >= ? AND start_time <= ?",DateTime.parse(params[:start]),DateTime.parse(params[:end]))
		return psts
	end
end
