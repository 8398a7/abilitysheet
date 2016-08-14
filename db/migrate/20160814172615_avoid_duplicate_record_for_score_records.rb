class AvoidDuplicateRecordForScoreRecords < ActiveRecord::Migration
  def change
    Score.find_each do |score|
      next if score.valid?
      p score
      score.destroy
    end
    add_index :scores, %i(version sheet_id user_id), unique: true
  end
end
