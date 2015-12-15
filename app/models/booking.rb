class Booking < ActiveRecord::Base
  belongs_to :listing
  belongs_to :user
  has_many :time_slots

  def receipient(current_user)
    if current_user.id == self.listing.user.id
      return self.user.first_name
    else
      return self.listing.user.first_name
    end
  end

   def other_party(this_user)
    if this_user.id == self.listing.user.id
      self.user
    else
      self.listing.user
    end
  end

  def calculate_total
    timeSlots=self.time_slots
    total=0
    timeSlots.each do |timeSlot|
      total+=timeSlot.parking_slot.daily_price
    end
    return total
  end
end
