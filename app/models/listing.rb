class Listing < ActiveRecord::Base
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :availability_slots, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  #---zino
  has_many :parking_slots, dependent: :destroy
  has_attached_file :photo, styles: { large: "500x500>", thumb: "100x100>" }, default_url: "missing.jpg"

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  geocoded_by :address
  before_save :geocode

  def first_name
    self.user.first_name
  end

  def average_rating
    if self.reviews.length > 0
      ratings = self.reviews
      sum = 0
      ratings.each do |rating|
        sum += rating.review_score
      end
      return sum / ratings.length
    else
      return 0
    end
  end

  def self.filter_time(input_listings,startDateInput,endDateInput)
    startDateBeginning=DateTime.parse(startDateInput)
    startDateBeginning=startDateBeginning.beginning_of_day
    endDateEnd=DateTime.parse(endDateInput)
    endDateEnd=endDateEnd.end_of_day

    output_listings=[]
    input_listings.each do |listing|
      listing.parking_slots.each do |ps|
        unless ps.time_slots.where("start_time >= ? AND start_time <= ?",startDateBeginning, endDateEnd).exists?
          output_listings.push(listing)
          break
        end
      end
    end

    return output_listings
  end
end
