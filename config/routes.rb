Rails.application.routes.draw do
  # get 'transactions/new'
  # get 'users/new'
  # get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  get "users/:id" => "users#show"
  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"


  # get "transactions/index" => "transactions#index"
  get "transactions/new" => "transactions#new"
  post "transactions/search" => "transactions#search"
  post "transactions/create" => "transactions#create"
  # get "transactions/up" => "transactions#up"
  # get "transactions/:id" => "transactions#show"
  post "transactions/:id/destroy" => "transactions#destroy"
  get "transactions/:id/remind" => "transactions#remind"

  get "/"	=> "home#top"
  get "about" => "home#about"

end
