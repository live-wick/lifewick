class Api::V1::WicksController < Api::V1::BaseController
  swagger_controller :wicks, 'Create Wick'

  swagger_api :create do |api| 
    summary 'Creating New Wick'
    param :header, 'Authorization', :string, :required, "Authorization"
    param :query, "name", :string, :required, 'Wick Name'
  end

	def create
		@wick = current_resource_owner.wicks.new(name: params[:name])
		if @wick.save
			render json: { message: "Wick created successfully", result: @wick }, status: 200
		else
			render json: { message: @wick.errors.full_messages.join(', '), result: @wick }, status: 401
		end
	end

  def get_user_all_wicks
    @my_wicks = current_resource_owner.wicks
    @shared_wicks = Share.shared_user_wicks(current_resource_owner.id).map(&:shareable)
    @shared_wicks = Wick.where(id: @shared_wicks.map(&:id)) if @shared_wicks.present?

    @followed_wicks = Share.followed_user_wicks(current_resource_owner.id).map(&:shareable)
    @followed_wicks = Wick.where(id: @followed_wicks.map(&:id)) if @followed_wicks.present?

    if @my_wicks.present?
      results = {}
      results.merge!(my_wicks: @my_wicks.select([:id, :name]).map {|e| {id: e.id, name: e.name, strands_count: e.strands_count} } )
      results.merge!(shared_wicks: @shared_wicks.present? ? (@shared_wicks.select([:id, :name]).map {|e| {id: e.id, name: e.name, strands_count: e.strands_count} }) : [])
      results.merge!(followed_wicks: @followed_wicks.present? ? (@followed_wicks.select([:id, :name]).map {|e| {id: e.id, name: e.name, strands_count: e.strands_count} }) : [])
      
      render json: {results: results }, status: 200
    else
      render json: { message: "No Wicks found", result: [] }, status: 401
    end
  end
end
