class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :availability_slots, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  #---zino
  has_many :parking_slots, dependent: :destroy

  geocoded_by :address
  before_save :geocode

  def first_name
    self.user.first_name
  end
end
