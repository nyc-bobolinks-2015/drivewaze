class UserMailer < ActionMailer::Base
  default from: "teamdrivewaze@gmail.com"

  def booked(booking)
    @renter = booking.user
    @listing = booking.listing
    @booking = booking
    mail(to: @listing.user.email, subject: "Your space has been booked!").deliver
  end

  def self.send_request(listing)
    bookers = listing.bookings.map(&:user)
    
    bookers.each do |booker|
      delete(booker,listing)
    end
  end

  def delete(booker, listing)
  	@booker = booker
  	mail(to: booker.email, subject: "Your Booked Parking Space is Going Away!").deliver
  end
end
