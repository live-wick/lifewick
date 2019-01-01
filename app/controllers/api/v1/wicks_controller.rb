class Api::V1::WicksController < Api::V1::BaseController

	def create
		@wick = current_resource_owner.wicks.new(name: params[:name])
		if @wick.save
			render json: { message: "Wick created successfully", result: @wick }, status: 200
		else
			render json: { message: @wick.errors.full_messages.join(', '), result: @wick }, status: 401
		end
	end
end
