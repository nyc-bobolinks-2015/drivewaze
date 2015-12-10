class Booking < ActiveRecord::Base
    belongs_to :listing
    belongs_to :user
    has_many :availability_slots
end
