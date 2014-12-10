Rails.application.routes.draw do

  root 'scoreboard#index'

  scope path: 'scoreboard', as: 'scoreboard' do
    get ''             => 'scoreboard#index'
    get ':year'        => 'scoreboard#by_year'
    get ':year/:month' => 'scoreboard#by_month'
  end

  post 'payload', :to => 'webhooks#receive'

  resources :coders, only: [:index, :show]
  resources :bounties, only: [:index] do
    post 'update_or_create', on: :collection
  end

  devise_for :coders, :controllers => { :omniauth_callbacks => "coders/omniauth_callbacks" }
  devise_scope :coder do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_session
  end

  controller :repositories do
    get 'repositories' => :index, as: 'index'
    get ':user/:repo'  => :show, as: 'show'
  end
end
