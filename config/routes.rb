Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  get 'relationships/follower'
  get 'relationships/followed'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  devise_for :users
  get "home/about"=>"homes#about", as: "about"

    resources :books, only: [:new,:index,:show,:edit,:create,:destroy,:update] do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
    resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create,:destroy]
    get "followings" => "relationships#followings", as: "followings"
  	get "followers" => "relationships#followers", as: "followers"
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

