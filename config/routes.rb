Rails.application.routes.draw do
  devise_for :users, path: '',
  path_names: {
    sign_in: 'signin', # POST
    sign_out: 'signout', # DELETE
    registration: 'signup' # POST
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  },
  defaults: { format: :json }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :admin do
    resources :users
    resources :user_approvals
    resources :user_transactions
  end

  resources :transactions do
    get 'index', on: :collection
    get 'show', on: :collection
    post 'buy', on: :collection
    post 'sell', on: :collection
  end

  resources :user_balances do
    get 'index', on: :collection
    get 'show', on: :collection
    get 'transactions', on: :collection
    post 'add_balance', on: :collection
    post 'withdraw_balance', on: :collection
    get 'investment', on: :collection
  end

  resources :stocks, only: [:index, :show] do
    get 'search', on: :collection
  end

  get 'watchlist/top', to: 'watchlist#top'
  get 'watchlist/news', to: 'watchlist#news'
  get 'watchlist', to: 'watchlist#index'
  get 'watchlist/:symbol', to: 'watchlist#show'

  get 'user/:id', to: 'user#show'
  
end