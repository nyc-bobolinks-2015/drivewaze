class FavoriteListingsController<ApplicationController
  before_action :set_listing

  def create
    if Favorite.create(favorited: @listing, user: current_user)
      redirect_to root_path
      flash[:notice] = 'Listing has been favorited'
    else
      redirect_to root_path
      flash[:alert] = 'Something went wrong.'
    end
  end

  def destroy
    Favorite.where(favorited_id: @listing.id, user_id: current_user.id).first.destroy
    redirect_to root_path
    flash[:notice] = 'Listing is no longer in favorites'
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id] || params[:id])
  end
end
