class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :state, null: false, default: 7
      t.integer :score
      t.integer :bp
      t.integer :sheet_id, null: false
      t.integer :user_id, null: false
      t.integer :version, null: false

      t.timestamps
    end

    add_index :scores, :sheet_id
    add_index :scores, :user_id
  end
end
