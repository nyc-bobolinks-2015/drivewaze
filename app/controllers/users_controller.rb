class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def stripe_signup
  	render :'users/stripe-signup'
  end

  def destroy
  	user = User.find_by(id: params[:id])
  	user.destroy
  	session.clear
  	redirect_to root_path
  end
end

