class Api::V1::StrandsController < Api::V1::BaseController


  swagger_controller :Strands, 'Strand Management'

  swagger_api :create do |api| 
    summary 'Search User by Email or Name'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "title", :string, :required, 'Title'
    param :query, "notes", :string, :optional, 'Notes'
    param :query, "address", :string, :optional, 'Address'
    param :query, "start_date", :datetime, :optional, 'Start Date'
    param :query, "end_date", :datetime, :optional, 'End Date'
    param :query, "all_day", :boolean, :optional, 'All Day'
    param :query, "repeat_daily", :boolean, :optional, 'Repeat Daily'
    param :query, "repeat_weekly", :boolean, :optional, 'Repeat Weekly'
    param :query, "repeat_monthly", :boolean, :optional, 'Repeat Monthly'
    param :query, "repeat_yearly", :boolean, :optional, 'Repeat Yearly'
    param :query, "latitude", :string, :optional, 'Latitude'
    param :query, "longitude", :string, :optional, 'Longitude'
    param :query, "remind_me_on", :string, :optional, 'Remind me on'
    param :query, "wick_id", :string, :required, 'Wick ID'

  end


  swagger_api :get_all_strands do |api| 
    summary "Get User's All Strands"
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
  end

  swagger_api :add_attachments do |api| 
    summary "Add Attachements For Strand"
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :path, "strand_id", :integer, :required, 'Strand ID'
    param :query, "files[]", :file, :required, 'File'
  end

  swagger_api :update do |api| 
    summary "Update Strand"
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :path, "id", :integer, :required, 'Strand ID'
    param :query, "title", :string, :required, 'Title'
    param :query, "notes", :string, :optional, 'Notes'
    param :query, "address", :string, :optional, 'Address'
    param :query, "start_date", :datetime, :optional, 'Start Date'
    param :query, "end_date", :datetime, :optional, 'End Date'
    param :query, "all_day", :boolean, :optional, 'All Day'
    param :query, "repeat_daily", :boolean, :optional, 'Repeat Daily'
    param :query, "repeat_weekly", :boolean, :optional, 'Repeat Weekly'
    param :query, "repeat_monthly", :boolean, :optional, 'Repeat Monthly'
    param :query, "repeat_yearly", :boolean, :optional, 'Repeat Yearly'
    param :query, "latitude", :string, :optional, 'Latitude'
    param :query, "longitude", :string, :optional, 'Longitude'
    param :query, "remind_me_on", :string, :optional, 'Remind me on'
    param :query, "wick_id", :string, :required, 'Wick ID'
  end

  def create
    wick = Wick.find(params[:wick_id])
    @strand = wick.strands.new(
      title: params[:title],
      notes: params[:notes],
      address: params[:address],
      start_date: params[:start_date].to_datetime,
      end_date: params[:end_date].to_datetime,
      all_day: params[:all_day],
      repeat_daily: params[:repeat_daily],
      repeat_weekly: params[:repeat_weekly],
      repeat_monthly: params[:repeat_monthly],
      repeat_yearly: params[:repeat_yearly],
      latitude: params[:latitude],
      longitude: params[:longitude],
      remind_me_on: params[:remind_me_on],
      user_id: current_resource_owner.id,
      wick_name: wick.name,
      is_public: params[:shared_strand_users].present? ? false : true,
      is_private: params[:shared_strand_users].present? ? true : false
    )
    if @strand.save
      shared_strand_user_ids = params[:shared_strand_users].present? ? params[:shared_strand_users] : User.pluck(:id)
      shared_strand_user_ids.present? && shared_strand_user_ids.each do |receiver_id|
        shared_user = @strand.shares.new(
          sender_id: current_resource_owner.id,
          receiver_id: receiver_id
        )
        begin
          shared_user.save!
        rescue
          render json: { message: "Error in sharing strands", result: @strand }, status: 401
        end
      end
      render json: { message: "Strand created successfully", result: @strand }, status: 200
    else
      render json: { message: @strand.errors.full_messages.join(', '), result: @strand }, status: 401
    end
  end

  def get_all_strands
    wick_ids = current_resource_owner.wicks.pluck(:id)
    user_created_strands = Strand.where(wick_id: wick_ids).to_a
    followed_strands = Share.followed_user_strands(current_resource_owner.id).map(&:shareable)
    @all_strands = (user_created_strands + followed_strands).uniq.sort_by(&:created_at).reverse!
    # @all_strands = Strand.all.order('created_at DESC')
    if @all_strands.present?
      results = []
      @all_strands.each do |strand|
        attachments = strand.attachments.map{|att| url_for(att)}
        results << strand.as_json.merge!(files: attachments).merge!(shared_with_users: strand.shares.map(&:receiver))
      end
      render json: {results: results }, status: 200
    else
      render json: { message: "No Strands found", result: [] }, status: 401
    end
  end

  def add_attachments
    strand = Strand.find(params['strand_id'])
    strand.attachments.destroy_all if strand.attachments.attached?
    params['files'].each do |filee|
      strand.attachments.attach(filee)
    end
    render json: {message: "Attachments are successfully uploaded"}, status: 200
  end

  def update
    wick = Wick.find(params[:wick_id])
    @strand = Strand.find(params[:id])
    if @strand.update(
      title: params[:title],
      notes: params[:notes],
      address: params[:address],
      start_date: params[:start_date].to_datetime,
      end_date: params[:end_date].to_datetime,
      all_day: params[:all_day],
      repeat_daily: params[:repeat_daily],
      repeat_weekly: params[:repeat_weekly],
      repeat_monthly: params[:repeat_monthly],
      repeat_yearly: params[:repeat_yearly],
      latitude: params[:latitude],
      longitude: params[:longitude],
      remind_me_on: params[:remind_me_on],
      user_id: current_resource_owner.id,
      wick_name: wick.name,
      is_public: params[:shared_strand_users].present? ? false : true,
      is_private: params[:shared_strand_users].present? ? true : false
    )
      shared_strand_user_ids = params[:shared_strand_users].present? ? params[:shared_strand_users] : User.pluck(:id)
      if shared_strand_user_ids.present?
        @strand.shares.destroy_all
        @strand.attachments.destroy_all
        shared_strand_user_ids.each do |receiver_id|
          shared_user = @strand.shares.new(
            sender_id: current_resource_owner.id,
            receiver_id: receiver_id
          )
          begin
            shared_user.save!
          rescue
            render json: { message: "Error in sharing strands", result: @strand }, status: 401
          end
        end
      end
      render json: {result: @strand, message: "Strand is successfully updated" }, status: 200
    else
      render json: { message: @strand.errors.full_messages.join(', '), result: [] }, status: 401

    end



  end

  private
  def strand_params
    params[:strand].permit(:title, :notes, :address, :start_date, :end_date, :all_day, :repeat_daily, :repeat_weekly, :repeat_monthly, :repeat_yearly, :latitude, :longitude, :remind_me_on, :user_id, :wick_name, :is_public, :is_private)
  end

  # def get_strand_attachments
  #   strand = Strand.find(params['strand_id'])
  #   attachments = strand.attachments
  #   if attachments.present?
  #     render json: {results: attachments.map{|att| [att.id, url_for(att)]}}, status: 200
  #   else
  #     render json: { message: "No Attachments found", result: [] }, status: 401
  #   end

  # end
end