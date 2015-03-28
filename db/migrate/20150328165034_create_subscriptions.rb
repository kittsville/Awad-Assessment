class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.text :feed
      t.datetime :subscriptiondate

      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
  end
end
