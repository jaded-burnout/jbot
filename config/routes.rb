Rails.application.routes.draw do
  get "/login", to: "authentication#login_form"
  post "/login", to: "authentication#authenticate"
  post "/logout", to: "authentication#logout"

  get "/setup", to: "authentication#setup"

  get "/authentication/something-awful/identify", to: "authentication#something_awful_identify"
  patch "/authentication/something-awful/identify", to: "authentication#something_awful_verify", as: "authentication_something_awful_verify"

  get "/authentication/discord/callback", to: "authentication#discord_callback"
  post "/authentication/discord/disconnect", to: "authentication#disconnect_discord"

  resources :servers, except: [:new, :show]

  root to: "servers#index"
end
