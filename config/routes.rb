Rails.application.routes.draw do
  get 'shop/index'
  # Swagger UI and API docs
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")
  root "shop#index"

  resources :products, only: [:index, :show, :create, :new, :update, :destroy]
  resources :orders, only: [:index, :show, :create]


end
