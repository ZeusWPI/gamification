Rails.application.routes.draw do
  get 'issues/index'
  get 'issues/:id', :to => 'issues#show'

  root 'coders#index'

  post 'payload', :to => 'webhooks#receive'

  devise_for :coders, :controllers => { :omniauth_callbacks => "coders/omniauth_callbacks" }
  devise_scope :coder do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  resources :coders, only: [:index, :show]
  resources :bounties, only: [:index] do
    post 'update_or_create', on: :collection
  end
end
