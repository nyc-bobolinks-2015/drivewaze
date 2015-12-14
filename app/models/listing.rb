class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :availability_slots, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  #---zino 
  #Don't leave comments in master
  has_many :parking_slots, dependent: :destroy

  geocoded_by :address
  before_save :geocode

  #You can use delegation for this - 
  # `delegate :first_name, to: user` would work
  def first_name
    self.user.first_name
  end
end
