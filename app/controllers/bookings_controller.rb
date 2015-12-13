class BookingsController < ApplicationController
	def new
		@listing = Listing.find_by(id: params[:listing_id])
		@user = User.first
	end

	def create
		#create_booking
		charge_client
		listing = Listing.find_by(id: params[:listing_id])
		@provider = listing.user
		render :'create'
	end

	private

	def charge_client
		# Amount in cents
		@amount = 500
		listing = Listing.find_by(id: params[:listing_id])
	  
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
	 		:application_fee => @amount/10
	  )

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_booking_path
	end
end
