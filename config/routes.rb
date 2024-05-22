Rails.application.routes.draw do


  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers:{
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    post '/users/general_guest_sign_in', to: 'users/sessions#general_guest_sign_in'
    post '/users/admin_guest_sign_in', to: 'users/sessions#admin_guest_sign_in'
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

  resources :children, only:[:create,:update, :new, :edit, :destroy ]
  get'children/search_education_expenses', to:'children#search_education_expenses'
  post 'children/destroy_for_fail_save', to:'children#destroy_for_fail_save'

  # 上のどのルーティングにも当てはまらない場合のルーティング
  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'

end
