class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :body
      t.integer :state
      t.boolean :active, default: true

      t.date :created_at
    end
  end
end
