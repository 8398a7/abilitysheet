class CreateAbilities < ActiveRecord::Migration[5.1]
  def change
    create_table :abilities do |t|
      t.integer :sheet_id
      t.float :fc
      t.float :exh
      t.float :h
      t.float :c
      t.float :e
      t.float :aaa

      t.timestamps null: false
    end
    add_index :abilities, :sheet_id
  end
end
