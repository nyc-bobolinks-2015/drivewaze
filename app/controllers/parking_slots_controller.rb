class ParkingSlotsController < ApplicationController
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

	def edit
		if params[:request]="property_type"
			render partial: "property_type", layout:false
		else
			render "error",layout:false
		end
	end	

	private
	# def parking_slot_params
	# 	params.require(:parking_slot).permit()
	# end
end
