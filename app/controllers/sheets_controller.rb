class SheetsController < ApplicationController
  before_action :load_user
  before_action :check_action, except: %i(change_reverse detail)

  def show
    load_static unless params[:type] == 'power'
    # FIXME: params[:type]から判別できるのでpower以外はコントローラ通さなくて良い
    # フロント部分も結構変更が必要かも
    __send__(@action_routes[params[:type]])
    render @action_routes[params[:type]]
  end

  private

  def load_user
    @user = User.find_by_iidxid!(params[:iidxid])
  end

  def check_action
    @action_routes = {
      'power' => :power,
      'clear' => :clear,
      'hard' => :hard
    }
    raise ActionController::RoutingError unless @action_routes[params[:type]]
  end

  def power
    @sheets = Sheet.active.preload(:ability)
    @color = Score.convert_color(@user.scores.is_current_version)
  end

  def clear
    @sheet_type = 0
  end

  def hard
    @sheet_type = 1
  end

  def load_static
    @versions = Static::VERSION.dup
    @versions.push(['ALL', 0])
  end
end
