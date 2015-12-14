class Booking < ActiveRecord::Base
    belongs_to :listing
    # Maybe use a more meaningful name here like "booker"
    belongs_to :user
    has_many :availability_slots

    #This might help
    delegate :user, to: :listing, prefix: true

    #This is name probably too specific to messaging? Maybe call it other party or something?
    def receipient(current_user)
    if current_user.id == self.listing.user.id
     return self.user.first_name
    else
      return self.listing.user.first_name
    end
  end

  def space_belongs_to? some_user
    listing_user == some_user
  end

  def other_party_to_booking some_user
    if space_belongs_to? some_user
      self.user
    else
      self.listing_user
    end
  end
end
