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
    get 'users' => 'users/registrations#index'
    get 'users/edit_user/:id' => 'users/registrations#edit_user', as: 'edit_user'
    put 'users/update_user/:id' => 'users/registrations#update_user', as: 'update_user'
    delete 'users/:id' => 'users/registrations#destroy', as: 'delete_user'
  end
  resources :locations, only: [:index]
  get 'locations/*id/' => 'locations#show', as: 'location'
  get '/about' => 'about#index'
  post '/feedback' => 'feedback#create'
  get '.well-known/status' => 'status#check_status'
  get '/api/analytics' => 'analytics#all'
end
