class Api::V1::WicksController < Api::V1::BaseController
  swagger_controller :wicks, 'Wick Management'

  swagger_api :create do |api| 
    summary 'Creating New Wick'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "name", :string, :required, 'Wick Name'
  end

  swagger_api :get_user_all_wicks do |api| 
    summary 'Get User Wicks'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
  end

  swagger_api :get_handshake_wicks do |api|
    summary 'Get Handshake Wicks'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "handshake_id", :integer, :required, 'Handshake ID'
  end

  swagger_api :share_handshake_wick do |api|
    summary 'Share Handshake Wick'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "handshake_id", :integer, :required, 'Handshake ID'
    param :path, "wick_id", :integer, :required, 'Wick ID'
  end

  swagger_api :unshare_handshake_wick do |api|
    summary 'Unshare Handshake Wick'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "handshake_id", :integer, :required, 'Handshake ID'
    param :path, "wick_id", :integer, :required, 'Wick ID'
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

  def get_handshake_wicks
    wicks = current_resource_owner.wicks
    handshake = Handshake.find(params[:handshake_id])
    opponent_id = current_resource_owner.id == handshake.sender_id ? handshake.receiver_id : handshake.sender_id
    results = []
    wicks.each do |wick|
      if wick.shares.find_by(receiver_id: opponent_id).present?
        results << wick.as_json.merge(is_shared: true)
      else
        results << wick.as_json.merge(is_shared: false)
      end
    end

    render json: {results: results }, status: 200

  end

  def share_handshake_wick
    handshake = Handshake.find(params[:handshake_id])
    opponent_id = current_resource_owner.id == handshake.sender_id ? handshake.receiver_id : handshake.sender_id
    wick = current_resource_owner.wicks.find(params[:wick_id])
    unless wick.shares.find_by(receiver_id: opponent_id).present?
      share = wick.shares.create(sender_id: current_resource_owner.id, receiver_id: opponent_id)
      render json: {results: share, message: "Wick is shared successfully" }, status: 200
    else
      render json: {results: [], message: "Wick is already shared with the user" }, status: 422
    end
  end

  def unshare_handshake_wick
    handshake = Handshake.find(params[:handshake_id])
    opponent_id = current_resource_owner.id == handshake.sender_id ? handshake.receiver_id : handshake.sender_id
    wick = current_resource_owner.wicks.find(params[:wick_id])
    share_wick = wick.shares.find_by(receiver_id: opponent_id)
    if share_wick.present?
      share = share_wick.destroy
      render json: {results: share, message: "Wick is un shared successfully" }, status: 200
    else
      render json: {results: [], message: "Wick is already not shared with the user" }, status: 422
    end
  end

end
