Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/root', to: "welcome#index"
  # get :root, to: 'welcome#index'

  get '/merchants', to: "merchants#index"
  get '/merchants/new', to: "merchants#new"
  post '/merchants', to: "merchants#create"
  get '/merchants/:id', to: "merchants#show"
  get '/merchants/:id/edit', to: "merchants#edit"
  patch '/merchants/:id', to: "merchants#update"
  delete '/merchants/:id', to: "merchants#destroy"
  get '/merchants/:merchant_id/items', to: "items#index"
  # resources :merchants do
  #   resources :items, only: [:index]
  # end

  get '/items', to: "items#index"
  get '/items/:id', to: "items#show"
  # resources :items, only: [:index, :show] do

  get '/items/:id/reviews/new', to: "reviews#new"
  post '/items/:id/reviews', to: "reviews#create"
  get '/reviews/:id/edit', to: "reviews#edit"
  patch '/reviews/:id', to: "reviews#update"
  delete '/reviews/:id', to: "reviews#destroy"
  #   resources :reviews, only: [:new, :create]
  # end
  # resources :reviews, only: [:edit, :update, :destroy]

  get '/cart', to: 'cart#show'
  patch '/cart/coupon', to: 'cart#apply_coupon'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration

  get '/users', to: "users#create"
  post '/users', to: "users#update"
  # resources :users, only: [:create, :update]

  patch '/user/:id', to: 'users#update'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard

    get '/orders', to: "orders#show"
    # resources :orders, only: :show

    get '/items/new', to: "items#new"
    post '/items', to: "items#create"
    get '/items/edit', to: "items#edit"
    patch '/items', to: "items#update"
    get '/items', to: "items#index"
    delete 'items/:id', to: "items#destroy"
    # resources :items, except: [:show]

    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'

    get '/items/new', to: "items#new"
    post '/items', to: "items#create"
    get '/items/edit', to: "items#edit"
    patch '/items', to: "items#update"
    get '/items', to: "items#index"
    delete 'items/:id', to: "items#destroy"
    # resources :coupons
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard

    get '/merchants/show', to: "merchants#show"
    patch '/merchants/show', to: "merchants#update"
    # resources :merchants, only: [:show, :update]

    get '/users', to: "users#index"
    post '/users/:user_id', to: "users#show"
    # resources :users, only: [:index, :show]

    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
