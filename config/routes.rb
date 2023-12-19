Rails.application.routes.draw do

  devise_for :admin, skip: [:passwords, :registrations], controllers: {
  sessions: "admin/sessions"
}

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: "public/sessions"
}

  namespace :admin do
    get "top" => "homes#top", as: "top"
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:show, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end

  scope module: :public do
    root to: "homes#top"
    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
      collection do
        get 'hashtag/:name', to: 'posts#hashtag', as: 'hashtag'
        get :search
        get :filter_by_date
      end
    end
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get :favorites
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
