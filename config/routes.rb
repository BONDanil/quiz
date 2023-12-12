Rails.application.routes.draw do
  root 'pages#main'
  resources :questions
  resources :categories
  resources :quiz_sessions, only: %i[new create show] do
    member do
      put 'start', to: 'quiz_sessions#start'
    end
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :attachments, only: %i[destroy]
  get 'quiz_sessions/:id/play', to: 'player/quiz_sessions#show'
end
