class AddExhTosheet < ActiveRecord::Migration[5.1]
  def change
    add_column :sheets, :exh_ability, :integer
  end
end
