class AddMoreToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :origin, :string
    add_reference :projects, :user, foreign_key: true
    add_column :projects, :description, :string
    add_column :projects, :active, :boolean
    add_column :projects, :origin_id, :integer
  end
end
