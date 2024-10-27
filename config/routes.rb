Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get 'homes/about' => "homes#about"
  get "search" => "searches#search"
  resources :dms, only: [:create, :show, :index]
  resources :dmrooms, only: [:create, :index, :show]
  resources :posts do
    resources :bookmarks, only: [:create, :destroy]
    resources :post_comments
  end
  resources :tags


  resources :posts, only: [:new, :create]
  resources :users, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'followings' => 'relationships#followings', as: 'followings'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
