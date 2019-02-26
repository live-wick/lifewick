class Api::V1::UsersController < Api::V1::BaseController

  swagger_controller :Users, 'User Management'

  swagger_api :fetch_users do |api| 
    summary 'Search User by Email or Name'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "email", :string, :optional, 'Email Address'
    param :query, "name", :string, :optional, 'User Full Name'
  end

  def fetch_users
    if params[:email].present?
      @users = User.where(email: params[:email])
    end

    if params[:name].present?
      @users = @users.present? ? @users.search_by_full_name(params[:name]) :  User.search_by_full_name(params[:name])
    end

    if @users.present?
      render json: {results: @users }, status: 200
    else
      render json: { message: "No User found", results: [] }, status: 401
    end
  end
end
