Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  devise_for :users
  get "home/about"=>"homes#about", as: "about"

  resources :books, only: [:new,:index,:show,:edit,:create,:destroy,:update] do
  end
  resources :users, only: [:index,:show,:edit,:update]
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

