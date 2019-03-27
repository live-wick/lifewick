class Api::V1::UsersController < Api::V1::BaseController

  swagger_controller :Users, 'User Management'

  swagger_api :fetch_users do |api| 
    summary 'Search User by Email or Name'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "email", :string, :optional, 'Email Address'
    param :query, "name", :string, :optional, 'User Full Name'
  end

  swagger_api :search_users_for_handshake do |api| 
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

  swagger_api :send_friend_request do |api| 
    summary 'Send Friend Request'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "email", :string, :required, 'Email'
  end

  swagger_api :cancel_friend_request do |api| 
    summary 'Cancel Friend Request'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "email", :string, :required, 'Email'
  end

  swagger_api :get_recieved_handshakes do |api| 
    summary 'Get Received Handshakes'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
  end

  swagger_api :accept_friend_request do |api| 
    summary 'Accept Friend Request'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "handshake_id", :integer, :required, 'Hand Shake ID'
  end

  swagger_api :reject_friend_request do |api| 
    summary 'Reject Friend Request'
    param :header, 'Authorization', :string, :required, "e.g Bearer [ACCESS TOKEN RETRIEVED DURING SIGN IN API]"
    param :query, "handshake_id", :integer, :required, 'Hand Shake ID'
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

  def send_friend_request
    begin
      sender = current_resource_owner
      receiver = User.find_by(email: params[:email])
      if (Handshake.find_by(sender_id: current_resource_owner.id, receiver_id: receiver.id)).present?
        render json: {message: "Request Already sent" }, status: 422
      else
        handshake = sender.send_friend_requests.new
        handshake.receiver_id = receiver.id
        handshake.notified = true
        handshake.status = 0
        if handshake.save
          result = handshake.as_json.except('created_at', 'updated_at', 'sender_id', 'receiver_id').merge(sender: handshake.sender_request_user, receiver: handshake.receiver_request_user)
          render json: {results: result, message: "Friend request is sent and approval is pending" }, status: 200
        else
          render json: {message: handshake.errors.full_messages.join(', ') }, status: 401
        end
      end
    rescue Exception => e
      render json: {message: e}, status: 500
    end
  end

  def cancel_friend_request
    begin
      sender = current_resource_owner
      receiver = User.find_by(email: params[:email])
      handshake = Handshake.find_by(sender_id: current_resource_owner.id, receiver_id: receiver.id)
      if handshake.present?
        if handshake.destroy
          result = handshake.as_json.except('created_at', 'updated_at', 'sender_id', 'receiver_id').merge(sender: handshake.sender_request_user, receiver: handshake.receiver_request_user)
          render json: {results: result, message: "Friend request is cancelled" }, status: 200
        else
          render json: {message: handshake.errors.full_messages.join(', ') }, status: 401
        end
      else
        render json: {message: "No Handshake Found" }, status: 422
      end
    rescue Exception => e
      render json: {message: e}, status: 500
    end
  end

  def get_recieved_handshakes
    begin
      results = []
      sender = current_resource_owner
      handshakes = sender.received_friend_requests.valid_handshakes
      handshakes.each do |handshake|
        handshake_user = handshake.sender_request_user
        avatar = url_for(handshake_user.avatar) if handshake_user.avatar.attached?
        user_result = handshake_user.as_json.merge(avatar: avatar)
        results << handshake.as_json.except('created_at', 'updated_at', 'sender_id', 'receiver_id').merge(user: user_result)
      end
      render json: {results: results}, status: 200
    rescue Exception => e
      render json: {message: e}, status: 500
    end
  end

  def accept_friend_request
    begin
      sender = current_resource_owner
      handshake = sender.received_friend_requests.find(params[:handshake_id])
      if handshake.update!(result_date: DateTime.now, status: 1)
        render json: {results: handshake, message: "Friend request is accepted"}, status: 200
    else
      render json: {message: handshake.errors.full_messages.join(', ') }, status: 401
    end
    rescue Exception => e
      render json: {message: e}, status: 500
    end
  end

  def reject_friend_request
    begin
      sender = current_resource_owner
      handshake = sender.received_friend_requests.find(params[:handshake_id])
      if handshake.update!(result_date: DateTime.now, status: -1)
        render json: {results: handshake, message: "Friend request is rejected"}, status: 200
    else
      render json: {message: handshake.errors.full_messages.join(', ') }, status: 401
    end
    rescue Exception => e
      render json: {message: e}, status: 500
    end
  end

  def search_users_for_handshake
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
        handshakes = user.received_friend_requests.where(sender_id: current_resource_owner.id).where.not(status: 1)
        results << user.as_json.merge!(avatar: avatar).merge!(status: handshakes.present? ? handshakes.first.status : nil)
      end
      render json: {results: results, message: "" }, status: 200
    else
      render json: { message: "No User found", results: [] }, status: 401
    end
  end
end
