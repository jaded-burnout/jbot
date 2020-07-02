class CreateForum < ActiveRecord::Migration[5.2]
  def change
    create_table :forums do |t|
      t.string :something_awful_id, null: false, unique: true
      t.timestamps
    end

    create_table :forum_permissions do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :forum, null: false, index: true
      t.boolean :moderator, null: false, default: false

      t.timestamps
    end

    add_column :users, :something_awful_id, :string, unique: true
  end
end
