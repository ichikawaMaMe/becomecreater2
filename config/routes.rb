Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get 'homes/about' => "homes#about"
  get "search" => "searches#seach"
  resources :dms, only: [:create, :show]
  resources :dmrooms, only: [:create, :index, :show]
  resources :posts do
    resources :bookmarks, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
    get :tags, on: :collection
  end

  resources :posts, only: [:new, :create]
  resources :users, only: [:show, :edit, :update] do
    resource :relationshoips, only: [:create, :destory]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
