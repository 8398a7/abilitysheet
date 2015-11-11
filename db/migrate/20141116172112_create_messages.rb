class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.string :email
      t.inet :ip, null: false
      t.integer :user_id
      t.boolean :state, default: false

      t.timestamps null: false
    end
    add_index :messages, :user_id
  end
end
