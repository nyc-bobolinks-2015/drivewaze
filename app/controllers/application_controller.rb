class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :configure_permitted_parameters, if: :devise_controller?

   protected

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email,:password, :password_confirmation, :phone)}
  end

  def owns?(listing)
    current_user == listing.user
  end

  def total(time_slots)
    time_slots.inject(0){|total, time_slot| total + time_slot.parking_slot.daily_price}
  end

  def confirm_times(time_slots)
    time_slots.map{|slot| slot.start_time.strftime("%m/%d/%Y")}
  end
end
