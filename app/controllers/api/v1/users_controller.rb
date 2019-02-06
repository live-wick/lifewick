class Api::V1::UsersController < Api::V1::BaseController

  def fetch_users
    if params[:email].present?
      @users = User.where(email: params[:email])
    end

    if params[:user_name].present?
      @users = @users.present? ? @users.where(user_name: params[:user_name]) :  User.where(user_name: params[:user_name])
    end

    if @users.present?
      render json: {results: @users }, status: 200
    else
      render json: { message: "No User found", results: [] }, status: 401
    end
  end
end
