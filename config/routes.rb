Rails.application.routes.draw do
  # Health check route for ALB
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }

  resources :posts

  # Defines the root path route ("/")
  root "posts#index"
end
