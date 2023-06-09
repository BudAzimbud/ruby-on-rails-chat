Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #add our register route
  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'
  post 'messages', to: 'messages#created'
  get 'messages', to: 'messages#index'
  get 'messages/:id', to: 'messages#detail'
  get 'contacts', to: 'users#contact'
  
end
