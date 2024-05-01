Rails.application.routes.draw do


  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers:{
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  get 'top/main', to:'top#main'
  resources :households
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'top#main'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at:"/letter_opener"
  end

  get'properties/get_selected_household', to:'properties#get_selected_household'
  get'properties/update_net_property_to_include_adjust_input', to:'properties#update_net_property_to_include_adjust_input'
  resources :properties

  resources :children, only:[:create,:update]
  get'children/search_education_expenses', to:'children#search_education_expenses'
  

end
