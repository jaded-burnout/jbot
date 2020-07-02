class AddVerifiedFlagsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :discord_verified, :boolean, null: false, default: false
    add_column :users, :something_awful_verified, :boolean, null: false, default: false
  end
end
