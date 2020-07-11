class AddNameToServer < ActiveRecord::Migration[5.2]
  def change
    add_column :servers, :name, :string
  end
end
