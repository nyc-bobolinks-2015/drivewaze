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
    startDateBeginning=DateTime.parse(startDateInput).beginning_of_day
    endDateEnd=DateTime.parse(endDateInput).end_of_day

    output_listings=[]
    input_listings.each do |listing|
      listing.parking_slots.each do |ps|
        unless ps.time_slots.where("start_time >= ? AND start_time <= ?",startDateBeginning, endDateEnd).exists?
          output_listings.push(ps.listing)
          break
        end
      end
    end

    return output_listings
  end

  def self.calendar(offset)

      inputTime=(DateTime.now+offset.months).beginning_of_day
      today=DateTime.now
      firstDayOfThisMonth=today.beginning_of_month
      viewArray=[]
      currentMonth=inputTime.strftime("%-m")
      firstDayOfMonth=inputTime.beginning_of_month
      lastDayOfMonth=inputTime.end_of_month
      lastDayOfPrevMonth=firstDayOfMonth.yesterday
      if firstDayOfMonth.strftime("%w")=="0"
        tmpWeekEnd=firstDayOfMonth
      else
        firstDayInView=firstDayOfMonth.beginning_of_week.yesterday #this is always be a sunday

        firstRow=[]
        firstRow.push(firstDayInView)

        tmpDay=firstDayInView.tomorrow
        while tmpDay <= lastDayOfPrevMonth
          firstRow.push(tmpDay)
          tmpDay=tmpDay.tomorrow
        end

        firstRow.push(firstDayOfMonth)
        tmpDay=firstDayOfMonth.tomorrow
        tmpWeekEnd=tmpDay.end_of_week
        while tmpDay.strftime("%-d") < tmpWeekEnd.strftime("%-d")
          firstRow.push(tmpDay)
          tmpDay=tmpDay.tomorrow
        end
        # p tmpDay
        viewArray.push(firstRow)
      end

      counter=0
      tmpArray=[]
      while tmpWeekEnd <=lastDayOfMonth
        if counter%7==0 && counter!=0
          viewArray.push(tmpArray)
          tmpArray=[]
        end
        tmpArray.push(tmpWeekEnd)
        counter+=1
        tmpWeekEnd=tmpWeekEnd.tomorrow
      end

      while tmpWeekEnd<tmpWeekEnd.end_of_week
        tmpArray.push(tmpWeekEnd)
        tmpWeekEnd=tmpWeekEnd.tomorrow
      end
      viewArray.push(tmpArray)

      return viewArray
  end
end
