class AddAuthenticationFields < ActiveRecord::Migration[5.2]
  def change
    create_table :server_permissions do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :server, null: false, index: true
      t.boolean :moderator, null: false, default: false

      t.timestamps
    end

    add_column :users, :discord_id, :string, unique: true
  end
end
