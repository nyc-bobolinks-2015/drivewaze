class User < ActiveRecord::Base
  has_many :bookings
  has_many :listings
  has_many :reviews, as: :reviewable
end
