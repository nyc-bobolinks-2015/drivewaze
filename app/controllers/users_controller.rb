class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(params[:id])
  end

  
end