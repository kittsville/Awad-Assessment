class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :description
      t.string :url
      t.boolean :blacklisted

      t.timestamps null: false
    end
  end
end
