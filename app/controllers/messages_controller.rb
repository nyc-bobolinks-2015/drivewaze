class MessagesController < ApplicationController

  def new
    @users = User.all
  end

  def create
    @message = Message.create!(params[:message])
  end
end