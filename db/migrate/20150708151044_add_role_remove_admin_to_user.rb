class AddRoleRemoveAdminToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0, null: false
    remove_column :users, :admin
  end
end
