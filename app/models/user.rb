class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  has_many :bookings, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :favorites, as: :favorited, dependent: :destroy
  has_many :favorite_listings, through: :favorites, source: :favorited, source_type: "Listing", dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :favorited, source_type: "User", dependent: :destroy
end
