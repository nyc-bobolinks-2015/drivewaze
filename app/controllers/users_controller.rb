class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:id])
  end

  def stripe_signup
  	render :'users/stripe-signup'
  end

  def edit
  	@user = User.find_by(id: params[:id])
  end

  def update

  	@user = User.find_by(id: params[:id])
    @user.skip_reconfirmation!
  	if @user.update_attributes(strong_params)

  		redirect_to user_path(@user)
  	else
  		flash[:alert] = @user.errors.full_messages
  		render :'edit'
  	end
  end

  def destroy
  	user = User.find_by(id: params[:id])
  	user.destroy
  	session.clear
  	redirect_to root_path
  end

  private

  def strong_params
  	params.require(:user).permit(:email, :first_name, :last_name, :phone, :zipcode, :description, :avatar)
  end
end

