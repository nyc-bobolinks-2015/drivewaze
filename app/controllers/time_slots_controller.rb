class TimeSlotsController < ApplicationController
	def create
		parking_slot=ParkingSlot.find(params[:parking_slot_id])
		start_time=DateTime.parse(params[:time]).beginning_of_day
		end_time=start_time
		parking_slot.time_slots.find_or_create_by(unavailable:true, start_time:start_time, end_time:end_time)
		render json:{status:"success"}
	end

end