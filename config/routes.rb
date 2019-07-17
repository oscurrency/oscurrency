
Oscurrency::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :person_sessions
  resources :password_resets, :only => [:new, :create, :edit, :update]
  resources :member_preferences
  resources :neighborhoods, :only => [:show]
  resources :invitations, :only => [:edit, :update]
  resources :privacy_settings, :only => [:update]
  resources :posts, :only => [:index]

  # XXX in 2.3.x, this was easier -> map.resources :transacts, :as => "transacts/:asset"
  get    "transacts(/:asset)/new"      => "transacts#new",     :as => 'new_transact'

  get    "transacts(/:asset)/:id(.:format)"      => "transacts#show",    :as => 'transact'
  # FIXME: as can't be duplicated
  # delete "transacts(/:asset)/:id(.:format)"      => "transacts#destroy", :as => 'transact'

  get    "transacts(/:asset)(.:format)"          => "transacts#index",   :as => 'transacts'
  # FIXME: as can't be duplicated
  # post   "transacts(/:asset)(.:format)"          => "transacts#create",  :as => 'transacts'

  #get    "transacts/[:asset]/:id/edit" => "transacts#edit",    :as => 'edit_transact'
  #patch    "transacts/[:asset]/:id"      => "transacts#update",  :as => 'transact'


  resources :public_offers, only: [:index, :show], path: '/openoffers'

  resources :groups, :shallow => true do
    member do
      post :join
      post :leave
      get :people
      get :exchanges
      get :members
      get :graphs
      get :photos
      post :new_photo
      post :save_photo
      delete :delete_photo
    end
    resources :memberships
    resources :reqs
    resources :offers
    resource :forum
  end

  resources :bids
  resources :reqs do
    member do 
      post :deactivate
    end
    resources :bids
  end

  resources :offers do
    member do
      get :new_photo
      post :save_photo
    end
  end
  resources :categories

  resources :memberships do
    member do
      delete :unsuscribe
      post :suscribe
    end
  end

  resources :searches
  resources :activities
  resources :connections
  resources :photos do
    collection do
      get :default_profile_picture
      patch :update_default_profile_picture
      get :default_group_picture
      patch :update_default_group_picture
    end
  end
  resources :messages do
    collection do
      get :sent
      get :trash
      get :recipients
    end
    member do
      get :reply
      patch :undestroy
    end
  end
  resources :people do
    member do
      get :verify_email
      get :su
      get :unsu
      get :invite
      get :transaction_history
      post :transaction_history
      post :send_invite
      get :common_contacts
    end
    resources :messages
    resources :accounts
    resources :exchanges
    resources :addresses do
      member do
        post :choose
      end
    end
    resources :photos
    resources :connections
  end

  get 'people/verify/:id' => 'people#verify_email'

  resources :forums do
    resources :topics do
      resources :posts
    end
  end

  get '/signup' => 'people#new', :as => :signup
  get '/login' => 'person_sessions#new', :as => :login
  delete '/logout' => 'person_sessions#destroy', :as => :logout
  get '/credit_card' => 'person_sessions#credit_card', :as => :credit_card
  get '/refreshblog' => 'feed_posts#refresh_blog', :as => :refreshblog
  get '/about' => 'home#about', :as => :about
  get '/practice' => 'home#practice', :as => :practice
  get '/steps' => 'home#steps', :as => :steps
  get '/questions' => 'home#questions', :as => :questions
  get '/contact' => 'home#contact', :as => :contact
  get '/agreement' => 'home#agreement', :as => :agreement
  resources :oauth_clients
  get '/oauth/authorize' => 'oauth#authorize', :as => :authorize, via: [:get, :post]
  get '/oauth/token' => 'oauth#token', :as => :token
  get '/oauth/request_token' => 'oauth#request_token', :as => :request_token
  get '/oauth/access_token' => 'oauth#access_token', :as => :access_token
  get '/oauth/test_request' => 'oauth#test_request', :as => :test_request
  get '/oauth/scopes' => 'transacts#scopes', :as => :scopes
  get '/oauth/revoke' => 'oauth#revoke', :as => :revoke
  get '/oauth' => 'oauth#index', :as => :oauth
  get '/stripe_callback' => 'stripe#handle_callback'
  get '/about_user' => 'transacts#about_user', :as => :about_user
  get '/user_info' => 'transacts#user_info', :as => :user_info
  get '/wallet' => 'transacts#wallet', :as => :wallet
  get '/.well-known/host-meta' => 'home#host_meta', :as => :host_meta
  get '/home/show/:id' => 'home#show'
  root :to => 'home#index'
  get '/' => 'home#index', :as => :home
end
