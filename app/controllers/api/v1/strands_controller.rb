class Api::V1::StrandsController < Api::V1::BaseController

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
      wick_name: wick.name
    )
    if @strand.save
      params[:shared_strand_users].present? && params[:shared_strand_users].each do |receiver_id|
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
    @all_strands = Strand.where(wick_id: wick_ids).order('created_at DESC')
    # @all_strands = Strand.all.order('created_at DESC')
    if @all_strands.present?
      results = []
      @all_strands.each do |strand|
        attachments = strand.attachments.map{|att| url_for(att)}
        results << strand.as_json.merge!(files: attachments)
      end
      render json: {results: results }, status: 200
    else
      render json: { message: "No Strands found", result: [] }, status: 401
    end
  end

  def add_attachments
    strand = Strand.find(params['strand_id'])
    params['files'].each do |filee|
      strand.attachments.attach(filee)
    end
    render json: {message: "Attachments are successfully uploaded"}, status: 200
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