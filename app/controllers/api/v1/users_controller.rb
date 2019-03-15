class Api::V1::UsersController < Api::V1::BaseController

  swagger_controller :Users, 'User Management'

  swagger_api :fetch_users do |api| 
    summary 'Search User by Email or Name'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "email", :string, :optional, 'Email Address'
    param :query, "name", :string, :optional, 'User Full Name'
  end

  swagger_api :get_user do |api| 
    summary 'Get User Info'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
  end


  swagger_api :add_avatar do |api| 
    summary 'Add User Avatar'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "avatar", :file, :required, 'Avatar'
  end

  def fetch_users
    if params[:email].present?
      @users = User.where(email: params[:email])
    end

    if params[:name].present?
      @users = @users.present? ? @users.search_by_full_name(params[:name]) :  User.search_by_full_name(params[:name])
    end

    if @users.present?
      results = []
      @users.each do |user|
        avatar = url_for(user.avatar) if user.avatar.attached?
        results << user.as_json.merge!(avatar: avatar)
        render json: {results: results }, status: 200
      end
    else
      render json: { message: "No User found", results: [] }, status: 401
    end
  end

  def add_avatar
    current_resource_owner.avatar.purge if current_resource_owner.avatar.attached?
    current_resource_owner.avatar.attach(params[:avatar])
    
    render json: {message: "Avatar is successfully uploaded", avatar: url_for(current_resource_owner.avatar)}, status: 200
  end

  def get_user
    user = current_resource_owner
    additional_emails = user.additional_emails.pluck(:email)
    avatar = url_for(user.avatar) if user.avatar.attached?
    result = user.as_json.merge(additional_emails: additional_emails, avatar: avatar)
    render json: result
  end
end
