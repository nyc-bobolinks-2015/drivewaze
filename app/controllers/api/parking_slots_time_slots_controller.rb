class Api::ParkingSlotsTimeSlotsController < ApplicationController
	def index
		# parking_slot=ParkingSlot.find(params[:parking_slot_id])
		@psts=ParkingSlotsTimeSlot.current(params)
	end
end