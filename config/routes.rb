Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # Read more about routing: http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get "users" => "users/registrations#index"
  end
  resources :locations, only: [:index]
  get 'locations/*id/' => 'locations#show', as: 'location'
  get '/about' => 'about#index'
  post '/feedback' => 'feedback#create'
  get '.well-known/status' => 'status#check_status'
end
