class AddIndexUpdatedAtToScores < ActiveRecord::Migration
  def change
    add_index :scores, :updated_at
  end
end
