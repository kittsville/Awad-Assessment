class FeedController < ApplicationController
  # GET /feeds.json
  # Fetches all of the logged in user's subscriptions or (if not logged in) 10 feeds
  def get_feeds
    if user_signed_in?
      @feeds = Feed.joins(:subscriptions).where(:subscriptions => { user_id: current_user.id }).all
    else
      @feeds = Feed.limit(10)
    end
    
    render json: @feeds
  end
end
