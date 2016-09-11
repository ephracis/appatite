class CreateApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :application_settings do |t|
      t.boolean :gitlab_enabled
      t.string :gitlab_url
      t.string :gitlab_id
      t.string :gitlab_secret
      t.boolean :github_enabled
      t.string :github_id
      t.string :github_secret

      t.timestamps
    end
  end
end
