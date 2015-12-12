class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :bookings
  has_many :listings
  has_many :reviews, as: :reviewable


end
