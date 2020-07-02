class AddNameToForum < ActiveRecord::Migration[5.2]
  def change
    add_column :forums, :name, :string
    add_index :forums, :name
  end
end
