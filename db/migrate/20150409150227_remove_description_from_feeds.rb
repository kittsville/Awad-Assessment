class RemoveDescriptionFromFeeds < ActiveRecord::Migration
  def change
    remove_column :feeds, :description
  end
end
