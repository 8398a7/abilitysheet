class CreateSheets < ActiveRecord::Migration[5.1]
  def change
    create_table :sheets do |t|
      t.string :title
      t.integer :n_ability
      t.integer :h_ability
      t.integer :version
      t.boolean :active, null: false, default: true
      t.string :textage

      t.timestamps null: false
    end
  end
end
