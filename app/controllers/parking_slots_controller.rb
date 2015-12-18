require 'zin_calendar'
class ParkingSlotsController < ApplicationController
	def calendar
		@parking_slot=ParkingSlot.find(params[:id])
		offset=params[:offset].to_i

		inputTime=(DateTime.now+offset.months).beginning_of_day
		@test=inputTime
		@today=DateTime.now
		@firstDayOfThisMonth=@today.beginning_of_month
		@currentMonth=inputTime.strftime("%-m")
		@viewArray=ZinCalendar::get_calendar(offset)

		@blackoutArray=[]
		blackoutTimeSlots=@parking_slot.time_slots.where("start_time >= ? OR end_time >= ?",@today.beginning_of_day,@today.beginning_of_day)

		blackoutTimeSlots.each do |blackout_time|
			blackout_start=blackout_time.start_time.beginning_of_day
			# if blackout_start<DateTime.now.beginning_of_day
			# 	blackout_start=DateTime.now.beginning_of_day
			# end

			blackout_end=blackout_time.end_time.beginning_of_day
			while blackout_start<=blackout_end
				@blackoutArray.push(blackout_start.strftime("%m/%d/%Y"))
				blackout_start=blackout_start+1.day
			end
		end
		p @blackoutArray
		render "calendar", layout:false
	end

	def index
		listing=Listing.find(params[:listing_id])
		@parking_slots=listing.parking_slots
	end

	def new
		@parking_slot=ParkingSlot.new
		@listing_id=params[:listing_id]
	end

	def create
		listing = Listing.find(params[:listing_id])
		params[:quantity].to_i.times do
			parking_slot=listing.parking_slots.build
			unless parking_slot.save
				flash[:error]=parking_slot.errors.full_messages
				redirect_to new_listing_parking_slot_path(listing.id)
			end
		end
		redirect_to listing_parking_slots_path(listing.id)
	end

	def show
		#Check if the belonging listing belongs to the current user, otherwise, redirect
		@parking_slot=ParkingSlot.find(params[:id])
	end

	def update
		parking_slot=ParkingSlot.find(params[:id])
		if params[:slot_type]
			parking_slot.update_attributes(slot_type:params[:slot_type])
		elsif params[:vehicle_class]
			parking_slot.update_attributes(vehicle_class:params[:vehicle_class])
		elsif params[:daily_price]
			parking_slot.update_attributes(daily_price:params[:daily_price])
		elsif params[:weekly_price]
			parking_slot.update_attributes(weekly_price:params[:weekly_price])
		elsif params[:monthly_price]
			parking_slot.update_attributes(monthly_price:params[:monthly_price])
		end

		if parking_slot.save
			render json:{status:"success"}
		else
			render json:{error:parking_slot.errors.full_messages.join(',')},status:406
		end


	end

	private
	# def parking_slot_params
	# 	params.require(:parking_slot).permit(:slot_type, :vehicle_class)
	# end
end
