class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings
  has_many :availability_slots
  has_many :reviews, as: :reviewable
  #---zino
  has_many :parking_slots

  geocoded_by :address
  before_save :geocode

  def first_name
    self.user.first_name
  end
end
