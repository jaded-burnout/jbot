class RemoveUserIdFromServer < ActiveRecord::Migration[5.2]
  def change
    remove_column :servers, :user_id, :integer
  end
end
