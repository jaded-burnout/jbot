class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
  end
end
