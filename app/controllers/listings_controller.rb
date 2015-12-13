class ListingsController < ApplicationController
  include HTTParty
  #=====zino===========
  def new
    @listing=Listing.new
  end

  def create
      listing = Listing.new(listing_params)
      if listing.save
        redirect_to new_listing_parking_slot_path(listing.id)
      else
        redirect_to new_listing_path
      end

  end
  #=====zino==========
  def show
    @listing = Listing.find_by(id: params[:id])
    @map_image = "https://maps.googleapis.com/maps/api/staticmap?
                  center=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&zoom=15&size=1000x1000&maptype=roadmap
                  &markers=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&key=#{ENV['GMAP_STATIC_KEY']}"

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

  def search_map
    search_term = URI.escape(params[:term])
    @response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=#{search_term}")
    render json: @response
  end

  private#zino----
  def listing_params
    params.require(:listing).permit(:info,:address)
  end
end
