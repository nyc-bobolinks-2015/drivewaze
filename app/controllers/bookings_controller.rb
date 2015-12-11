class BookingsController < ApplicationController
	def new
	end

	def create
		charge_client
		listing = Listing.find_by(id: params[:listing_id])
		@provider = listing.user
	end

	private

	def charge_client
		# Amount in cents
		@amount = 500
	  
	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => @amount,
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd',
	    # :destination => #some @provider.id not sure if 
	  )

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_booking_path
	end
end
