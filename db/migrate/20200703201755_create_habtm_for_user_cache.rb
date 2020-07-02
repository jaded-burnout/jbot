class CreateHabtmForUserCache < ActiveRecord::Migration[5.2]
  def change
    create_table :forums_something_awful_user_caches do |t|
      t.belongs_to :forum, index: true
      t.belongs_to :something_awful_user_cache, index: { name: "sa_user_cache_index" }

      t.timestamps
    end
  end
end
