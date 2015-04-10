Rails.application.routes.draw do
  root to: 'pages#index'
  get '/browse'       => 'feed#index'
  get '/add_feed'     => 'feed#new'
  post '/create_feed' => 'feed#create'
  
  # Only allows AJAX requests for a specific route
  class OnlyAjaxRequests
    def matches?(request)
      request.xhr?
    end
  end
  
  match '/feeds.json'            => 'feed#get_feeds', :constraints => OnlyAjaxRequests.new, via: :get, defaults: {format: 'json'}
  match '/modify_subscriptions'  => 'subscription#change', :constraints => OnlyAjaxRequests.new, via: :post, defaults: {format: 'json'}
  match '/modify_blacklisted'    => 'feed#blacklist', :constraints => OnlyAjaxRequests.new, via: :post, defaults: {format: 'json'}
  match '/search_feeds'          => 'feed#search_feeds', :constraints => OnlyAjaxRequests.new, via: :post, defaults: {format: 'json'}
  
  # Makes login/logout routes cleaner
  devise_for :users, :skip => [:sessions]
  as :user do
    get 'signin'    => 'devise/sessions#new', :as => :new_user_session
    post 'signin'   => 'devise/sessions#create', :as => :user_session
    match 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session,
      :via            => Devise.mappings[:user].sign_out_via
  end
end
