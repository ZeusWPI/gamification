Gamification::Application.routes.draw do
  root 'scoreboard#index'

  resources :scoreboard
end
