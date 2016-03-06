module Abilitysheet::V1
  class Logs < Grape::API
    resources :logs do
      desc '指定された月のログ情報を返す'
      params do
        requires :iidxid, type: String, desc: 'iidxid'
        requires :year, type: Integer, desc: '年情報'
        requires :month, type: Integer, desc: '月情報'
      end
      get ':iidxid/:year/:month' do
        user = User.find_by(iidxid: params[:iidxid])
        error! '404 Not Found', 404 unless user
        begin
          start_date = (params[:year].to_s + '-' + params[:month].to_s + '-01').to_date
        rescue
          error! '400 Bad Request', 400
        end
        end_date = start_date + 1.month
        logs = user.logs.where(created_date: start_date..end_date)
        ret = []
        logs.each do |log|
          ret.push(log.schema)
        end
        ret
      end

      desc 'cal-heatmap用'
      params do
        requires :iidxid, type: String, desc: 'iidxid'
        requires :start, type: DateTime, desc: '始まり日付'
        requires :stop, type: DateTime, desc: '終わりの日付'
      end
      get 'cal-heatmap/:iidxid' do
        user = User.find_by(iidxid: params[:iidxid])
        error! '404 Not Found', 404 unless user
        logs = user.logs.where(created_date: params[:start]..params[:stop]).map { |c| c.created_date.to_time.to_i }
        logs.each_with_object(Hash.new(0)) { |tm, h| h[tm] += 1 }
      end
    end
  end
end
