class AddApiUrlToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :api_url, :string
  end
end
