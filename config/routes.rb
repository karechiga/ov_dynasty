Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'  
  resources :players, only: :create
  resources :nba_teams, only: :create
end
