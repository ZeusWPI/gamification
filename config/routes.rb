Rails.application.routes.draw do


  root 'top4#show'
  get 'top4/show'

  scope path: 'scoreboard', as: 'scoreboard' do
    get '' => 'scoreboard#index'
    post '' => 'scoreboard#rows'
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

  resources :repositories, only: [:index, :show]

  scope ':organisation' do
    controller :repositories do
      get ':repository' => :show, as: :show
    end
  end

end
