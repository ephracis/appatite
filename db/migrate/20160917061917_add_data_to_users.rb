class AddDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :website, :string
    add_column :users, :location, :string
    add_column :users, :nickname, :string
  end
end
