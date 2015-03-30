class AddFeedReferenceToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :add_column, :string
    add_column :subscriptions, :, :subscription,
    add_reference :subscriptions, :feed, index: true
    add_foreign_key :subscriptions, :feeds
  end
end
