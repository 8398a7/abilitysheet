class CreateStatics < ActiveRecord::Migration
  def change
    create_table :statics do |t|
      t.integer :sheet_id
      t.float :fc
      t.float :exh
      t.float :h
      t.float :c
      t.float :e

      t.timestamps null: false
    end
    add_index :statics, :sheet_id
  end
end
