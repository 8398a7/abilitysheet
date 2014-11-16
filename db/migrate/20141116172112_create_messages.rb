class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.inet :ip, null: false
      t.integer :user_id
      t.boolean :state, default: false

      t.timestamps
    end
  end
end
