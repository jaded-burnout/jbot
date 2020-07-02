class CreateSomethingAwfulUserCache < ActiveRecord::Migration[5.2]
  def change
    create_table :something_awful_user_caches do |t|
      t.string :name
      t.string :something_awful_id, null: false

      t.timestamps
    end
  end
end
