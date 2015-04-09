class FeedController < ApplicationController
  # GET /feeds.json
  # Fetches all of the logged in user's subscriptions or (if not logged in) 10 feeds
  def get_feeds
    if user_signed_in?
      if params['type'] == 'index'
        @feeds = Feed.joins(:subscriptions).where(:subscriptions => { user_id: current_user.id }).all
      elsif params['type'] == 'browse'
        @feeds = Feed.limit(20)
      end
    else
      @feeds = Feed.limit(10)
    end
    
    render json: @feeds
  end

  # Gets all site feeds that the current user isn't subscribed to for user to browse
  def index
  end
  
  # Displays form to add a new feed
  def new
  end
  
  # Adds a new feed to the site's listing
  def create
    if !user_signed_in?
      return
    end

    feed = Feed.create(url: params['feed_url'], title: params['feed_title'])

    if !feed.valid?
      redirect_to root_path
    end

    feed.save

    subscription = Subscription.create!(user_id: current_user.id, feed_id: feed.id)

    puts "Created Feed #{feed.id} and subscription #{subscription.id}"

    redirect_to root_path
  end
end
