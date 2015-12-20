class DropRivalToUser < ActiveRecord::Migration
  def change
    remove_column :users, :rival
    remove_column :users, :reverse_rival
  end
end
