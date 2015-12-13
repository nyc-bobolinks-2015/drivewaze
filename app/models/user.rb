class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :bookings
  has_many :listings
  has_many :reviews, as: :reviewable
  has_many :favorites
  has_many :favorite_listings, through: :favorites, source: :favorited, source_type: "Listing"
  has_many :favorite_users, through: :favorites, source: :favorited, source_type: "User"
end
