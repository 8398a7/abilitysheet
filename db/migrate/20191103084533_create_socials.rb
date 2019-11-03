class CreateSocials < ActiveRecord::Migration[6.0]
  def change
    create_table :socials do |t|
      t.string :provider
      t.json :raw
      t.string :secret
      t.string :token
      t.string :uid
      t.bigint :user_id

      t.timestamps

      t.index %i[user_id provider], unique: true
    end
  end
end
