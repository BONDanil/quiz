Rails.application.routes.draw do
  root 'pages#main'
  resources :questions
  resources :categories
  resources :attachments, only: %i[destroy]

  resources :quiz_sessions, only: %i[index] do
    scope module: 'quiz_sessions' do
      resources :questions, only: %i[index]
      resources :players, only: %i[index]
    end
  end

  scope module: 'host' do
    resources :quiz_sessions, only: %i[new create show] do
      member do
        put 'start', to: 'quiz_sessions#start'
        put 'next', to: 'quiz_sessions#next'
        put 'mark_answer', to: 'quiz_sessions#mark_answer'
        put 'deactivate_player', to: 'quiz_sessions#deactivate_player'
        put 'activate_player', to: 'quiz_sessions#activate_player'
        put 'rating', to: 'quiz_sessions#rating'
      end
    end
  end

  scope module: 'player' do
    get 'quiz_sessions/:id/play', to: 'quiz_sessions#show'
    post 'quiz_sessions/:id/answer', to: 'quiz_sessions#answer'
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
end
