class CreateServer < ActiveRecord::Migration[5.2]
  def change
    create_table :servers do |t|
      t.string :discord_id, null: false, unique: true
      t.belongs_to :user, null: false
    end
  end
end
