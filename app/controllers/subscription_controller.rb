class SubscriptionController < ApplicationController
  # POST /modify_subscriptions
  # Subscribes or unsubscribes a user from a Feed
  def change
    if !user_signed_in?
      return
    end
    
    feed_id = Integer(params['feed_id'])
    
    subscription = Subscription.where({feed_id: feed_id, user_id: current_user.id}).first
    
    # If user wants to subscribe and hasn't already: subscribes user
    if params['change'] === 'sub' and subscription.blank?
      subObject = Subscription.create!({feed_id: feed_id, user_id: current_user.id})
      puts "Subscribed user ##{subObject.user_id} to feed ##{subObject.feed_id}"
      render json: true
      # If user is subscribed and wants to unsubscribe: unsubscribes user
    elsif params['change'] === 'unsub' and subscription.present?
      puts subscription.inspect
      subscription.destroy!
      puts "Un-Subscribed user ##{subscription.user_id} from feed ##{subscription.feed_id}"
      render json: true
    else
      render json: false
    end
  end
end
