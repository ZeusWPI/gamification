Rails.application.routes.draw do
  root 'coders#index'

  devise_for :coders, :controllers => { :omniauth_callbacks => "coders/omniauth_callbacks" }
  devise_scope :coder do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  resources :coders, only: [:index, :show]
end
