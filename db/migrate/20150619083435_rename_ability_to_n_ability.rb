class RenameAbilityToNAbility < ActiveRecord::Migration
  def change
    rename_column :sheets, :ability, :n_ability
  end
end
