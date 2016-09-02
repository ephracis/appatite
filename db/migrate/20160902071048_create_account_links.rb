class CreateAccountLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :account_links do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.boolean :expires
      t.timestamp :expires_at
      t.timestamp :updated_at
      t.timestamp :created_at
    end
  end
end
