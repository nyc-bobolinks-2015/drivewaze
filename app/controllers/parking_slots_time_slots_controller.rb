class ParkingSlotsTimeSlotsController < ApplicationController
	def new
		@parking_slot=ParkingSlot.find(params[:parking_slot_id])
		@psts=ParkingSlotsTimeSlot.new
	end

	def create
		@startTime=DateTime.parse(params[:start_time])
		@endTime=DateTime.parse(params[:end_time])
		parking_slot=ParkingSlot.find(params[:parking_slot_id])
		while @startTime != @endTime
			time_slot=TimeSlot.where("start_time = ?",@startTime)[0]
			parking_slot.parking_slots_time_slots.create(time_slot_id:time_slot.id,unavailable:true)
			# Remember DURATION
			@startTime=@startTime+2.hour
		end
		render "create",layout:false
	end

end
