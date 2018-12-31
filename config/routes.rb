Rails.application.routes.draw do
  use_doorkeeper
  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1 do
      devise_for :users, controllers: {
           registrations: 'api/v1/users/registrations',
       }, skip: [:sessions, :password]
    end
  end

  # root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
