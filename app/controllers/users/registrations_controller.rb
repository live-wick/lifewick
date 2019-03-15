# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  skip_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  swagger_controller :registrations, 'User Sign Up'
  swagger_api :create do |api| 
    summary 'Sign Up'
    param :query, "registration[email]", :string, :required, 'Email Address'
    param :query, "registration[password]", :string, :required, 'Password'

  end

  swagger_api :update do |api| 
    summary 'Account Update'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "registration[first_name]", :string, :optional, 'First Name'
    param :query, "registration[last_name]", :string, :optional, 'Last Name'
    param :query, "registration[email]", :string, :optional, 'Email Address'
    param :query, "registration[alias]", :string, :optional, 'unique Alias'
    param :query, "registration[mobile]", :string, :optional, 'Mobile no.'
    param :query, "registration[current_password]", :string, :optional, 'Current Password'
    param :query, "registration[password]", :string, :optional, 'New Password'
    param :query, "registration[birth_date]", :string, :optional, 'Birth Date'
    param :query, "additional_emails", :array, :optional, 'Additional Emails'
    

  end
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(configure_sign_up_params)
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        # To avoid login comment out sign_up method
        # sign_up(resource_name, resource)
        respond_to do |format|
          format.json { 
            render json: resource # , location: after_sign_up_path_for(resource)
          }
          format.html {respond_with resource, location: after_sign_up_path_for(resource)}
        end
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_to do |format|
            format.json { 
              render json: resource # , location: after_inactive_sign_up_path_for(resource)
            }
            format.html {respond_with resource, location: after_inactive_sign_up_path_for(resource)}
          end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.json { render json: { error_messages: resource.errors.full_messages.join(', ') }, status: 422 }
        format.html {respond_with resource}
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_resource_owner").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, configure_account_update_params)
    yield resource if block_given?

    if params[:additional_emails].present?
      resource.additional_emails.destroy_all
      additional_emails = []
      params[:additional_emails].each do |email|
        additional_emails << {email: email}
      end
    end
    
    if resource_updated

      resource.additional_emails.create(additional_emails) if params[:additional_emails].present?
      avatar = url_for(resource.avatar) if resource.avatar.attached?

      # set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name #if sign_in_after_change_password?
      respond_to do |format|
        format.json { 
          render json: resource.as_json.merge(additional_emails: resource.additional_emails.pluck(:email)).merge(avatar: avatar) # , location: after_sign_up_path_for(resource)
        }
        format.html {respond_with resource, location: after_update_path_for(resource)}
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.json { render json: { error_messages: resource.errors.full_messages.join(', ') }, status: 422 }
        format.html {respond_with resource}
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    if request.content_type == 'application/json'
      params[:registration].permit(:email, :password, :birth_date, :first_name, :last_name, :user_name)
    else
      params[:user].permit(:email, :password, :birth_date, :first_name, :last_name, :user_name)
    end
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    if request.content_type == 'application/json' || request.content_type == 'text/plain'
      params[:registration].permit(:email, :password, :birth_date, :first_name, :last_name, :alias, :current_password, :password, :mobile)
    else
      params[:user].permit(:email, :password, :birth_date, :first_name, :last_name, :alias, :current_password, :password, :mobile)
    end
  end

  def update_resource(resource, params)
    resource.update_without_password(params.except(:current_password))
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
