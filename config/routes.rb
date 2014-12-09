Rails.application.routes.draw do
  root 'leaderboard#index'

  scope path: 'leaderboard', as: 'leaderboard' do
    get '' => 'leaderboard#index'
    get ':year' => 'leaderboard#by_year'
    get ':year/:month' => 'leaderboard#by_month'
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

end
