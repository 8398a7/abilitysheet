class AddEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, default: '', null: false
  end
end
