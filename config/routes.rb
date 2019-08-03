Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'  
  resources :players, only: :index
  resources :leagues do
    resources :memberships, only: :create
    resources :homes, only: :index, :path => 'home'
    resources :rosters
  end
  
end
