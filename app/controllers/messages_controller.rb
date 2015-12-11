class MessagesController < ApplicationController


  def index

  end

  def new
    @booking = Booking.find_by(params[:booking_id])
    @message = Message.new
  end
end
