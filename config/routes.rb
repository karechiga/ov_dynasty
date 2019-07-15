Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'  
  resources :players, only: [:create, :update]
  resources :nba_teams, only: :create
end
