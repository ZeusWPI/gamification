Gamification::Application.routes.draw do
  root 'scoreboard#index'

  devise_for :coders, :controllers => { :omniauth_callbacks => "coders/omniauth_callbacks" }

  resources :scoreboard
  resources :coder
end
