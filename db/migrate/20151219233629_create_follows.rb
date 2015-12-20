class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :target_user_id

      t.timestamps null: false
    end
    add_index :follows, [:user_id, :target_user_id], unique: true
    User.select(:id, :rival).find_each do |user|
      next if user.rival.nil?
      user.rival.each do |rival_iidx_id|
        other_user_id = User.select(:id).find_by(iidxid: rival_iidx_id).id
        next if Follow.exists?(user_id: user.id, target_user_id: other_user_id)
        Follow.create(user_id: user.id, target_user_id: other_user_id)
      end
    end
  end
end
