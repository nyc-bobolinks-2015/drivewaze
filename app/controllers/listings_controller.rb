class ListingsController < ApplicationController
  include HTTParty

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

  def availability
    listing=Listing.find(params[:id])
    start_date=DateTime.parse(params[:start_date])
    depart_date=DateTime.parse(params[:depart_date])
    numOfDayLapsed=(depart_date-start_date).day
    numTimeSlots=numOfDayLapsed/2.hours

    parkingSlots=listing.parking_slots.where('vehicle_class >= ?', params[:vehicle_class].to_i)
    availability=false
    # available_parking_slot_id
    available_parking_slot_id=0

    parkingSlots.each do |ps|
      blackoutTimeSlots = ps.time_slots.where('start_time > ? AND start_time < ?',start_date,depart_date).count
      if blackoutTimeSlots<numTimeSlots
        availability=true
        available_parking_slot_id=ps.id
        break
      end
    end

    if availability
      output={
        status:"success",
        redirect: available_parking_slot_id
      }
      render json:output
    else
      render json:{status:"unavailable"}
    end
  end

  def search_map
    search_term = URI.escape(params[:term])
    @response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{search_term}")
    render json: @response
  end

  private#zino----
  def listing_params
    params.require(:listing).permit(:other_info,:address,:space_description,:neighborhood_info,:public_transit_info,:rules)
  end
end
