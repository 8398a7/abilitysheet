class AvoidDuplicateRecordForScoreRecords < ActiveRecord::Migration
  def change
    Score.find_each do |score|
      score.destroy unless score.valid?
    end
    add_index :scores, %i(version sheet_id user_id), unique: true
  end
end
