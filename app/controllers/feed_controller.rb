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
    
    # Initilises output to be returned
    @feed_full = []
    
    # Initilises feed subscribed
    subscribed = nil
    
    @feeds.each do |feed|
      # Stops non-admins seeing blacklisted feeds
      if feed.blacklisted
        if user_signed_in? and current_user.admin == 1
          blacklisted = true
        else
          next
        end
      else
          blacklisted = false
      end
      
      if user_signed_in?
        subscribed = Subscription.where({user_id: current_user.id, feed_id: feed.id}).first.present?
      end
      
      @feed_full.push([subscribed, feed, blacklisted])
    end
    
    render json: [user_signed_in?,  @feed_full, (user_signed_in? and current_user.admin == 1)]
  end
  
  # Blacklists or unblacklists a feed
  def blacklist
    # Ensures only a signed in admin may blacklist/unblacklist a feed
    if !user_signed_in? or !current_user.admin == 1
      render json: false
      return
    end
    
    feed_id = Integer(params['feed_id'])
    
    feed = Feed.find_by_id(feed_id)
    
    # If feed doesn't exit then fail request
    if !feed
      render json: false
      return
    end
    
    # If feed isn't blacklisted and admins wants to blacklist feed
    if params['bfeed'] == 'true' and !feed.blacklisted
      feed.blacklisted = true
    # If feed is blacklisted and admin wants to un-blacklist it
    elsif feed.blacklisted and (params['bfeed']) == 'false'
      feed.blacklisted = false
    else
      render json: false
      return
    end
    
    feed.save
    render json: true
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
