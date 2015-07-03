class UsersController < ApplicationController
  def index
    @cnt = User.count
    if params[:query] && params[:query].present?
      @users = User.search_djname(params[:query].upcase)
    else
      limit_count = 4000
      user_count = 0
      while user_count < 200
        limit_count *= 1.2
        @scores = Score.where('state <= 6').order(updated_at: :desc).limit(limit_count)
        @scores_map = {}
        user_ids = []
        @scores.each do |score|
          user_ids.push score.user_id
          @scores_map[score.user_id] ||= score
          @scores_map[score.user_id] = score if @scores_map[score.user_id].updated_at < score.updated_at
        end
        user_ids.uniq!
        user_count = user_ids.count
      end
      user_ids.slice!(200, user_ids.count - 1)
      @users = User.where(id: user_ids)
    end
  end
end
