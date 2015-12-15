class BookingsController < ApplicationController
	#current_user was returning nil in the create method because the ajax call
	#wasn't returning the CSRF token with Ajax
	#looks like the exact same problem as here: http://stackoverflow.com/questions/18423718/rails-devise-current-user-is-nil
	#this is a temporary solution.
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
				timeSlots=booking.time_slots
				@total=0
				@confirmed_times=[]
				timeSlots.each do |timeSlot|
					@total+=timeSlot.parking_slot.daily_price
					@confirmed_times.push(timeSlot.start_time.strftime("%m/%d/%Y"))
				end
			render "confirmation"
			return
		end
	end

	def create
		booking=Booking.find_or_initialize_by(user_id:current_user.id,listing:params[:listing_id])
		start_time=DateTime.parse(params[:time]).beginning_of_day
		end_time=start_time
		booking.time_slots.build(start_time:start_time,end_time:end_time,booked:true,parking_slot_id:params[:psid])
		booking.total= booking.calculate_total
		# p SESSION
		if booking.save
			
			render json:{status:"success", total: booking.total}
		else
			render json:{status:booking.errors.full_message}
		end
	end

	def complete
		# binding.pry
		charge_client
		listing = Listing.find_by(id: params[:id])
		@provider = listing.user
		@booking = Booking.first
		render :'bookings/order-complete'
	end

	def show
		# binding.pry
		@listing = Listing.find_by(id: params[:listing_id])
		@booking = Booking.first
		render :'confirmation'
	end


	private

	def charge_client
		# Amount in cents
		@amount = 500
		listing = Listing.find_by(id: params[:id])
	  
	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd',
	 		:destination => listing.user.uid,
	 		# :application_fee => @amount/10
	  )

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_booking_path
	end
end
