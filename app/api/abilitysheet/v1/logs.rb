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
    end
  end
end
