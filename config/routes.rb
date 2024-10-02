Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get 'home/about' => "homes#about"
  get "search" => "searches#seach"
  resources :dms, only: [:create, :show]
  resources :dmrooms, only: [:create, :index, :show]
  resources :posts do
    resources :bookmarks, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :posts, only: [:new, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
