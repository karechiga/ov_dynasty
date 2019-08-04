Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'  
  resources :players, only: :index
  resources :leagues do
    namespace :admin do
      resources :tools, only: [:index]
      resources :rosters
    end
    resources :memberships, only: [:create, :index, :update]
    resources :homes, only: :index, :path => 'home'
    resources :rosters
  end
  
end
