class ListingsController < ApplicationController
  include HTTParty
  skip_before_filter :verify_authenticity_token

  def new
    @listing=Listing.new
    @map_image = "https://maps.googleapis.com/maps/api/staticmap?center=#{@listing.address}&zoom=15&size=1000x1000&maptype=roadmap&markers=#{@listing.address}&key=#{ENV['GMAP_STATIC_KEY']}"
  end

  def create
      listing = Listing.new(listing_params.merge(user: current_user))
      if listing.save
        redirect_to new_listing_parking_slot_path(listing.id)
      else
        redirect_to new_listing_path
      end
  end

  def show
    @listing = Listing.find_by(id: params[:id])
    @map_image = "https://maps.googleapis.com/maps/api/staticmap?center=#{@listing.address}&zoom=15&size=1000x1000&maptype=roadmap&markers=#{@listing.address}&key=#{ENV['GMAP_STATIC_KEY']}"

    if request.xhr?
      return render partial: 'listing_preview', locals:{listing: @listing}
    end
  end

  def index
    @listings = Listing.all

    if request.xhr?
      return render json: @listings
    end
  end

  def destroy
    @listing = Listing.find_by(id: params[:id])
    redirect_to root_path unless owns?(@listing)
    UserMailer.send_request(@listing)
    @listing.destroy
    redirect_to root_path
  end

  def search
    westBound = params[:westBound]
    eastBound = params[:eastBound]
    southBound = params[:southBound]
    northBound = params[:northBound]
    @listings = Listing.where('latitude >= ?', southBound)
                .where('latitude <= ?', northBound)
                .where('longitude >= ?', westBound)
                .where('longitude <= ?', eastBound)

    return render json: @listings
  end

  def total
    listing=Listing.find(params[:id])
    booking=Booking.find_by(listing_id:params[:id],user_id:current_user.id)
    if booking
      total=booking.calculate_total
    else
      total=0
    end
    render json:{total:total}
  end


  def availability
    listing=Listing.find(params[:id])

    parkingSlots=listing.parking_slots.where('vehicle_class >= ?', params[:vehicle_class].to_i)
    if parkingSlots.length==0
      return render json:{status:"unavailable"}
    else
      if params[:psindex]
        @parking_slot=parkingSlots[params[:psindex].to_i]
      else
        @parking_slot=parkingSlots[0]
      end
      offset=params[:offset].to_i
      @pstotal=parkingSlots.length

      # def mc(inputTime) ---calendar rander
      inputTime=(DateTime.now+offset.months).beginning_of_day
      @test=inputTime
      @today=DateTime.now
      @firstDayOfThisMonth=@today.beginning_of_month
      @viewArray=[]
      @currentMonth=inputTime.strftime("%-m")
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
        @viewArray.push(firstRow)
      end

      counter=0
      tmpArray=[]
      while tmpWeekEnd <=lastDayOfMonth
        if counter%7==0 && counter!=0
          @viewArray.push(tmpArray)
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
      @viewArray.push(tmpArray)
      #---calendar render finished

      @blackoutArray=[]
      @selectedTimeSlots=[]
      blackoutTimeSlots=@parking_slot.time_slots.where("start_time > ? OR end_time > ?",@today,@today)

      blackoutTimeSlots.each do |blackout_time|
        blackout_start=blackout_time.start_time.beginning_of_day
        if blackout_start<DateTime.now.beginning_of_day
          blackout_start=DateTime.now.beginning_of_day
        end

        if blackout_time.booking_id && !blackout_time.booking.paid
          if blackout_time.booking.user == current_user
            @selectedTimeSlots.push(blackout_start.strftime("%m/%d/%Y"))
          end
        else
          blackout_end=blackout_time.end_time.beginning_of_day
          while blackout_start<=blackout_end
            @blackoutArray.push(blackout_start.strftime("%m/%d/%Y"))
            blackout_start=blackout_start+1.day
          end
        end

      end

      p @selectedTimeSlots
      p @blackoutArray

    return render "calendar",layout:false
    end#available

  end

  def search_map
    search_term = URI.escape(params[:term])
    @response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{search_term}")
    render json: @response
  end

  private#zino----
  def listing_params
    params.require(:listing).permit(:other_info,:address,:space_description,:neighborhood_info,:public_transit_info,:rules, :photo)
  end
end
