class ListingsController < ApplicationController
  include HTTParty
  def show
    @listing = Listing.find_by(id: params[:id])
    @map_image = "https://maps.googleapis.com/maps/api/staticmap?
                  center=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&zoom=15&size=500x500&maptype=roadmap
                  &markers=#{@listing.street},#{@listing.city},#{@listing.state},#{@listing.zipcode}&key=#{ENV['GMAP_STATIC_KEY']}"

    if request.xhr?
      return render partial: 'listing', locals:{listing: @listing}
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
end
