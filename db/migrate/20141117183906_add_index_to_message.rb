class AddIndexToMessage < ActiveRecord::Migration
  def change
    add_index :messages, :user_id
  end
end
