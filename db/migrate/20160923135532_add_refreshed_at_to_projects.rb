class AddRefreshedAtToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :refreshed_at, :timestamp
  end
end
