class AvailabilitySlot < ActiveRecord::Base
  belongs_to :booking
  belongs_to :listing
end
