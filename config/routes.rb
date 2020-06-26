Rails.application.routes.draw do
  get "/login", to: "authentication#login_form"
  post "/login", to: "authentication#authenticate"
  post "/logout", to: "authentication#logout"

  resources :servers, except: [:edit, :update]

  root to: "servers#index"
end
