class TimeSlotsController < ApplicationController
	def create
		parking_slot=ParkingSlot.find(params[:parking_slot_id])
		start_time=DateTime.parse(params[:time]).beginning_of_day
		end_time=start_time
		# parking_slot.time_slots.find_or_create_by(unavailable:true, start_time:start_time, end_time:end_time)
		if parking_slot.time_slots.where(start_time:start_time, end_time:end_time).exists?
			parking_slot.time_slots.find_by(start_time:start_time, end_time:end_time).destroy
			if start_time.strftime("%m%d%Y")==DateTime.now.strftime("%m%d%Y")
				render json:{status:"present"}
			elsif start_time.strftime("%m")==DateTime.now.strftime("%m")
				render json:{status:"this-month future"}
			else
				render json:{status:"future"}
			end
		else
			parking_slot.time_slots.build(unavailable:true, start_time:start_time, end_time:end_time)
			if parking_slot.save
				render json:{status:"success"}
			else
				render json:{status:parking_slot.errors.full_message}
			end
		end
	end

end