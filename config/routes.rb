Rails.application.routes.draw do
  get 'cart/index'
  get 'cart/checkout'
  post 'cart/checkout'
  delete 'cart/index', to:"cart#empty_cart"

  get 'cart/thankyou_page'
  resources :line_items
  get 'gallery/index'
  post 'gallery/search', as: 'search'
  resources :stores

  get 'admin/login'
  post 'admin/login'
  get 'admin/logout'

  devise_for :users

  root 'pages#index'
  get '/index', to:"pages#index"
  get '/about', to:"pages#about"

  resources :stores do
    member do
      delete :delete_file
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
