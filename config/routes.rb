Rails.application.routes.draw do
  root 'pages#main'
  resources :questions
  resources :categories
  resources :quiz_sessions, only: %i[new create show]
  devise_for :users
end
