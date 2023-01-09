Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "games#index"
  resources :games, only: :index do
    post 'answer', on: :collection
    post 'give_up', on: :collection
  end
end
