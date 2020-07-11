class AddDiscordTokensToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :discord_access_token, :string
    add_column :users, :discord_refresh_token, :string
  end
end
