Rails.application.routes.draw do
  get 'user/new'

  root 'main#index'

  resource :session, only: [:new, :create, :destroy]

  get "login" => "sessions#new"
  get "logout" => "sessions#destroy"

  get 'signup' => 'user#new'

  get 'wechat', to: 'wechat#show'
  get 'wechat/menu', to: 'wechat#menu'
  post 'wechat', to: 'wechat#create'



end
