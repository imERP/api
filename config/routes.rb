Rails.application.routes.draw do
  resources :departments
  resources :users

  post 'users/appply', to: 'users#appply'
  get 'users/applies', to: 'users#applies'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
