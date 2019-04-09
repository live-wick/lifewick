Rails.application.routes.draw do
  use_doorkeeper


  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1 do

      # devise_for :users, controllers: {
      #      registrations: 'api/v1/users/registrations',
      #  }, skip: [:sessions, :password]

      resources :wicks, only: :create do
        collection do
          get :get_user_all_wicks
          get :get_handshake_wicks
        end
        post :share_handshake_wick
        post :unshare_handshake_wick
      end

      resources :strands, only: [:create, :update, :destroy] do
        post :add_attachments
        post :add_comment
        get :get_comments
        collection do
          get :get_all_strands
        end
      end

      resources :users, only: :fetch_users do
        collection do
          get :fetch_users
          get :search_users_for_handshake
          post :add_avatar
          get :get_user
          post :send_friend_request
          post :cancel_friend_request
          get :get_recieved_handshakes
          put :accept_friend_request
          put :reject_friend_request
        end

      end
    end
  end

  resources :users, only: :dashboard do
    get :dashboard
  end


  # devise_scope :user do
  #   match "/users/sign_in" => "api/v1/users/sessions#new"
  # end

  devise_scope :user do
    root to: "users/sessions#new"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
