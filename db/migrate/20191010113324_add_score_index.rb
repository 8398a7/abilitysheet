class AddScoreIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :scores, %i[user_id version updated_at]
  end
end
