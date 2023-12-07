Rails.application.routes.draw do

  devise_for :admin, skip: [:passwords, :registrations], controllers: {
  sessions: "admin/sessions"
}
  namespace :admin do
    get 'top' => 'homes#top', as: "top"
  end

  devise_for :users, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

  scope module: :public do
    root to: 'homes#top'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
