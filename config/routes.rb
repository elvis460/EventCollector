Rails.application.routes.draw do
  root to: 'events#index'
  resources :events, only: [:index]
end
