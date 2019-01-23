class Api::V1::StrandsController < Api::V1::BaseController

  def create
    wick = Wick.find(params[:wick_id])
    @strand = wick.strands.new(
      title: params[:title],
      notes: params[:notes],
      address: params[:address],
      start_date: params[:start_date],
      end_date: params[:end_date],
      all_day: params[:all_day],
      repeat_daily: params[:repeat_daily],
      repeat_weekly: params[:repeat_weekly],
      repeat_monthly: params[:repeat_monthly],
      repeat_yearly: params[:repeat_yearly],
      latitude: params[:latitude],
      longitude: params[:longitude],
      remind_me_on: params[:remind_me_on],
      user_id: params[:user_id]
    )
    if @strand.save
      params[:shared_strand_users].present? && params[:shared_strand_users].each do |receiver_id|
        shared_user = @strand.shares.new(
          sender_id: current_resource_owner.id,
          receiver_id: receiver_id
        )
      end
      render json: { message: "Strand created successfully", result: @strand }, status: 200
    else
      render json: { message: @strand.errors.full_messages.join(', '), result: @strand }, status: 401
    end
  end

  def get_all_strands
    @all_strands = Strand.all

    if @all_strands.present?
      render json: {results: @all_strands }, status: 200
    else
      render json: { message: "No Strands found", result: [] }, status: 401
    end
  end
end