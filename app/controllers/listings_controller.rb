class ListingsController < ApplicationController

  def show
    @listing = Listing.find_by(id: params[:id])
    @map_image = "https://maps.googleapis.com/maps/api/staticmap?center=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&zoom=15&size=600x300&maptype=roadmap
&markers=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&key=#{ENV['GMAP_STATIC_KEY']}"
  end

  def index
    @listings = Listing.all

    if request.xhr?
      return render json: @listings
    end
  end

  def search
    lat = params[:lat]
    lng = params[:lng]
    Listing.where('lat >= ?', lat -1).where('lat <= ?', lat +1)
    .where('lng >= ?', lng -1).where('lng >= ?', lng +1)

  end

end
