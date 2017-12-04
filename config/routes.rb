Rails.application.routes.draw do
  resources :departments
  resources :users



  get 'wechat/departments/list', to: 'wechat#departmentlist'

  post 'wechat/login', to: 'wechat#login'
  post 'wechat/users/update', to: 'wechat#update'
  post 'wechat/users/delete', to: 'wechat#delete'

  get 'wechat/users/list', to: 'wechat#list'
  post 'wechat/users/appply', to: 'wechat#appply'
  get 'wechat/users/applies', to: 'wechat#applies'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
