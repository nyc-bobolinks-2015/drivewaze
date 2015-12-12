class Booking < ActiveRecord::Base
    belongs_to :listing
    belongs_to :user
    has_many :availability_slots

    def receipient(current_user)
    if current_user.id == self.listing.user.id
     return self.user.first_name
    else
      return self.listing.user.first_name
    end
  end
end
