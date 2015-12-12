class MessagesController < ApplicationController


  def index
  end

  def new
    @booking = Booking.find(params[:booking_id])
  end
end
