class AddValidateUniqLogRecord < ActiveRecord::Migration[5.0]
  def merge_logs(logs)
    hash = {
      id: logs.first.id,
      sheet_id: logs.first.sheet_id,
      user_id: logs.first.user_id,
      version: logs.first.version,
      created_date: logs.first.created_date,
      pre_state: 0,
      new_state: 7,
      pre_score: nil,
      new_score: nil,
      pre_bp: nil,
      new_bp: nil
    }
    logs.each do |log|
      hash[:pre_state] = log.pre_state if hash[:pre_state] < log.pre_state
      hash[:new_state] = log.new_state if log.new_state < hash[:new_state]
      if log.pre_score
        hash[:pre_score] ||= log.pre_score
        hash[:pre_score] = log.pre_score if log.pre_score < hash[:pre_score]
      end
      if log.new_score
        hash[:new_score] ||= log.new_score
        hash[:new_score] = log.new_score if hash[:new_score] < log.new_score
      end
      if log.pre_bp
        hash[:pre_bp] ||= log.pre_bp
        hash[:pre_bp] = log.pre_bp if hash[:pre_bp] < log.pre_bp
      end
      if log.new_bp
        hash[:new_bp] ||= log.new_bp
        hash[:new_bp] = log.new_bp if log.new_bp < hash[:new_bp]
      end
    end
    logs.destroy_all
    Log.create!(hash)
  end

  def change
    Log.find_each do |log|
      next if log.valid?
      logs = Log.where(sheet_id: log.sheet_id, user_id: log.user_id, created_date: log.created_date)
      merge_logs(logs)
    end
    add_index :logs, %i(created_date user_id sheet_id), unique: true
  end
end
