class ChangeUserlevelInUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :userlevel
      t.integer :admin, null: false, default: 0
    end
  end
end
