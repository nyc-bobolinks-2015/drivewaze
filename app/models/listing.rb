class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :availability_slots, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  #---zino
  has_many :parking_slots, dependent: :destroy
  has_attached_file :photo, styles: { large: "500x500>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  geocoded_by :address
  before_save :geocode

  def first_name
    self.user.first_name
  end
end
