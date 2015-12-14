class FavoriteUsersController<ApplicationController

  def create
    user = User.find(params[:user_id]) 
    if current_user.favorites.create(favorited: user)
      redirect_to root_path
      flash[:notice] = 'User has been favorited'
    else
      redirect_to root_path
      flash[:alert] = 'Something went wrong.'
    end
  end

  def destroy
    # !!? Be careful about type
    favorited_user = User.find(params[:id])
    current_user.favorites.where(favorited: favorited_user).destroy_all
    redirect_to root_path
    flash[:notice] = 'User is no longer in favorites'
  end
end
