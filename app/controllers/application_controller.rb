class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:nickname, :email, :password, :profile_picture)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:nickname, :email, :password, :current_password, :profile_picture)}
  end
end
