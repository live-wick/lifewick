class Api::V1::UsersController < Api::V1::BaseController

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
