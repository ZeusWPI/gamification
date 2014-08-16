Rails.application.routes.draw do
  root 'scoreboard#index'

  devise_for :coders, :controllers => { :omniauth_callbacks => "coders/omniauth_callbacks" }
  devise_scope :coder do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  resources :scoreboard
  resources :coder
end
