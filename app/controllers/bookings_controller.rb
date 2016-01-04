class BookingsController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def new
		@listing = Listing.find_by(id: params[:listing_id])
	end

	def confirmation
		booking=Booking.find_by(user_id:current_user.id,listing_id:params[:id])
		if params[:check]
			if booking.time_slots.length>0
				render json:{status:"success"}
			else
				render json:{status:"empty"}
			end
			return
		else
			time_slots=booking.time_slots
			@listing = Listing.find_by(id: params[:id])
			@total= total(time_slots)
			@confirmed_times = confirm_times(time_slots)
			render "confirmation"
			return
		end
	end

	def create
		booking=Booking.find_or_initialize_by(user_id:current_user.id,listing_id:params[:listing_id])
		start_time=DateTime.parse(params[:time]).beginning_of_day
		end_time=start_time
		if booking.time_slots.where(start_time:start_time,end_time:end_time).exists?
			booking.time_slots.find_by(start_time:start_time,end_time:end_time).destroy
			booking.total= booking.calculate_total
			if start_time.strftime("%m%d%Y")==DateTime.now.strftime("%m%d%Y")
				render json:{status:"present", total:booking.total}
			elsif start_time.strftime("%m")==DateTime.now.strftime("%m")
				render json:{status:"this-month future",total:booking.total}
			else
				render json:{status:"future", total:booking.total}
			end
		else
			booking.time_slots.build(start_time:start_time,end_time:end_time,booked:true,parking_slot_id:params[:psid])
			booking.total= booking.calculate_total
			if booking.save
				render json:{status:"success", total: booking.total}
			else
				render json:{status:booking.errors.full_message}
			end
		end
	end

	def show
		charge_client
		listing = Listing.find_by(id: params[:listing_id])
		@booking = listing.bookings.last
		UserMailer.booked(@booking)
		UserMailer.booker(@booking)
		render :'bookings/order-complete'
	end


	private

	def charge_client
		listing = Listing.find_by(id: params[:listing_id])
		time_slots=listing.bookings.last.time_slots
		@amount= total(time_slots) * 100 #turns to pennies

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd',
	 		:destination => listing.user.uid
	 		#TODO: set application_fee
	  )

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_booking_path
	end
end
