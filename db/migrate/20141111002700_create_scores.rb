class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.integer :state, null: false, default: 7
      t.integer :score
      t.integer :bp
      t.integer :sheet_id, null: false
      t.integer :user_id, null: false
      t.integer :version, null: false

      t.timestamps null: false
    end

    add_index :scores, :sheet_id
    add_index :scores, :user_id
    add_index :scores, :updated_at
    add_index :scores, %i(version sheet_id user_id), unique: true
  end
end
