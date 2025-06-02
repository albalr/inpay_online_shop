Rails.application.routes.draw do
  # Swagger UI and API docs
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")

  resources :products, only: [:index, :show, :create]
  resources :orders, only: [:index, :show, :create]


end
