class CreateCommits < ActiveRecord::Migration[5.0]
  def change
    create_table :commits do |t|
      t.string :sha
      t.string :message
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
