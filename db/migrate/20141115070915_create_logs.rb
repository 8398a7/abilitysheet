class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.integer :sheet_id
      t.integer :pre_state
      t.integer :new_state
      t.integer :pre_score
      t.integer :new_score
      t.integer :pre_bp
      t.integer :new_bp
      t.integer :version

      t.date :created_date
    end

    add_index :logs, :user_id
    add_index :logs, :sheet_id
    add_index :logs, %i(created_date user_id sheet_id), unique: true
  end
end
