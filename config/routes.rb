Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  #
  # Defines the root path route ("/")
  # root "posts#index"

  root to: 'application#health_check' # 動作確認用

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'logout', to: 'sessions#destroy', as: 'logout'
end
