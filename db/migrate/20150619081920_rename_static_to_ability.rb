class RenameStaticToAbility < ActiveRecord::Migration
  def change
    rename_table :statics, :abilities
  end
end
