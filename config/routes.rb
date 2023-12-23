Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index create show destroy], path: :todolists do
      resources :items, only: %i[index create]
    end
    resources :users, only: %i[index create show destroy], path: :users do
      post 'login', to: 'users#login', on: :collection
      delete 'logout', to: 'users#logout', on: :collection
    end
  end

  resources :todo_lists, only: %i[index new create show], path: :todolists
end
