Rails.application.routes.draw do
	devise_for :users, controllers: {
    sessions: "public/sessions",
    registrations: "public/registrations"
  }

  resources :users,only: [:show,:edit,:update,:index] do
    member do
      get 'followers' => 'relationships#followings'
      get 'followings' => 'relationships#followers' # フォロー外す
    end
    resource :relationships, only: [:create, :destroy]
  end
  
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create,:destroy]
    #resources :book_comments, only: []
  end

  

  root 'home#top'
  get 'home/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
