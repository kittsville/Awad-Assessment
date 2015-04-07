Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'
  
  # Only allows AJAX requests for a specific route
  class OnlyAjaxRequests
    def matches?(request)
      request.xhr?
    end
  end
  
  match '/feeds.json' => 'feed#get_feeds', :constraints => OnlyAjaxRequests.new, via: :get, defaults: {format: 'json'}
end
