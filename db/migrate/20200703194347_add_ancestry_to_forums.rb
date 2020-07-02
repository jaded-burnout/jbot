class AddAncestryToForums < ActiveRecord::Migration[5.2]
  def change
    add_column :forums, :ancestry, :string
    add_index :forums, :ancestry
  end
end
