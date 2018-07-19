class DropDoorkeeperTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :oauth_applications
    drop_table :oauth_access_grants
    drop_table :oauth_access_tokens
  end
end
