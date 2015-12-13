class FavoriteUsersController<ApplicationController
  before_action :set_user

  def create
    if Favorite.create(favorited: @user, user: current_user)
      redirect_to root_path
      flash[:notice] = 'User has been favorited'
    else
      redirect_to root_path
      flash[:alert] = 'Something went wrong.'
    end
  end

  def destroy
    Favorite.where(favorited_id: @user.id, user_id: current_user.id).first.destroy
    redirect_to root_path
    flash[:notice] = 'User is no longer in favorites'
  end

  private

  def set_user
    @user = User.find(params[:user_id] || params[:id])
  end
end
