class RemoveFeedFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :feed, :string
  end
end
