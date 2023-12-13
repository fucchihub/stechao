Rails.application.routes.draw do

  devise_for :admin, skip: [:passwords, :registrations], controllers: {
  sessions: "admin/sessions"
}

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  namespace :admin do
    get 'top' => 'homes#top', as: "top"
  end

  scope module: :public do
    root to: 'homes#top'
    resources :posts do
      get '/hashtag/:id' => "posts#hashtag"
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get :favorites
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
