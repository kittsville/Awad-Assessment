class AddFeedRefToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :feed, index: true
    add_foreign_key :subscriptions, :feeds
  end
end
