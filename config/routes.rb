Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'  
  resources :players, only: [:create, :update] do
    resources :contracts, only: :create
  end
  resources :nba_teams, only: :create
  resources :rosters do
    resources :picks, only: :create
    resources :players, only: [:create, :update] do
      resources :contracts, only: :create
    end
  end
  
end
