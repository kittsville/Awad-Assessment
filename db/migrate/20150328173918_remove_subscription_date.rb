class RemoveSubscriptionDate < ActiveRecord::Migration
  def change
    ActiveRecord::Migration.remove_column :subscriptions, :subscriptiondate
  end
end
