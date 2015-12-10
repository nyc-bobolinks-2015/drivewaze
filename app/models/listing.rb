class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings
  has_many :availability_slots
  has_many :reviews, as: :reviewable
end
