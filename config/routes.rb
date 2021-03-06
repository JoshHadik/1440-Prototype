Rails.application.routes.draw do
  root 'temp#root'

  devise_for :users

  resources :activity_logs, only: [:new, :create, :show, :destroy, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
