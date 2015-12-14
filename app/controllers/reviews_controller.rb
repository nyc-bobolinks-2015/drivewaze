class ReviewsController < ApplicationController

  def new
    params[:user_id] ? @reviewable = User.find(params[:user_id]) : @reviewable = Listing.find(params[:listing_id])
    @review = Review.new
  end

  def create
    if params[:user_id]
      @user = User.find(params[:user_id])
      @review = @user.reviews.build(review_params)
    else
      @listing = Listing.find(params[:listing_id])
      @review = @listing.reviews.build(review_params)
    end
    if @review.save
      if @user 
        redirect_to user_path(@user) 
      else 
        redirect_to listing_path(@listing)
      end
      flash[:notice] = "Your review has been saved!"
    else
      render :"reviews/new"
    end
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:review_body,:review_score).merge(user_id: current_user.id)
  end

end
