class ChangeColumnBigintFk < ActiveRecord::Migration[5.2]
  def change
    change_column :abilities, :sheet_id, :bigint

    change_column :follows, :user_id, :bigint
    change_column :follows, :target_user_id, :bigint

    change_column :logs, :user_id, :bigint
    change_column :logs, :sheet_id, :bigint

    change_column :messages, :user_id, :bigint

    change_column :scores, :sheet_id, :bigint
    change_column :scores, :user_id, :bigint
  end
end
