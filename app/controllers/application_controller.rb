class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

   respond_to :html, :json

  protected

  # Devise methods
  # Authentication key(:username) and password field will be added automatically by devise.
  def configure_permitted_parameters
    added_attrs = [:email, :first_name, :last_name]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || user_dashboard_path(resource) || root_path
  end

   private
  # Doorkeeper methods
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
