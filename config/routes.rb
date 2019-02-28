Rails.application.routes.draw do
  use_doorkeeper
  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1 do

      devise_for :users, controllers: {
           registrations: 'api/v1/users/registrations',
       }, skip: [:sessions, :password]

      resources :wicks, only: :create do
        collection do
          get :get_user_all_wicks
        end
      end

      resources :strands, only: [:create, :update] do
        post :add_attachments
        collection do
          get :get_all_strands
        end
      end

      resources :users, only: :fetch_users do
        collection do
          get :fetch_users
        end
      end
    end
  end
  # root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
