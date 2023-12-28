Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :admins
  resources :labels
  
  resources :users, only: [:new, :create, :show, :update, :destroy] do
    get 'edit', on: :member

    member do
      delete 'destroy_with_tasks'
    end
  end
  
  delete '/logout', to: 'sessions#destroy'

  #resources :users
  namespace :admin do
    resources :users
    resources :tasks
  end

  # エラーページ用のルート
  get '/errors/internal_server_error', to: 'errors#internal_server_error'
end