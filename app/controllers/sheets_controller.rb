class SheetsController < ApplicationController
  before_filter :check_action

  def show
    unless params[:type] == 'power'
      load_sheet
      load_state_example
    end
    __send__(@action_routes[params[:type]])
    render @action_routes[params[:type]]
  end

  private

  def check_action
    @action_routes = {
      'power' => :power,
      'clear' => :clear,
      'hard' => :hard
    }
    return_404 unless @action_routes[params[:type]]
  end

  def power
    @sheets = Sheet.active.preload(:ability)
    @color = Score.convert_color(
      User.find_by(iidxid: params[:iidxid]).scores
    )
  end

  def clear
    @sheets = @sheets.order(:n_ability, :title)
    @sheet_type = 0
    write_remain(0)
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
    @sheet_type = 1
    write_remain(1)
  end

  def write_remain(type)
    if type == 0
      remain_num = @scores.where(state: 5..7).size
      @remain = "☆12ノマゲ参考表(未クリア#{remain_num})"
    else
      remain_num = @scores.where(state: 3..7).size
      @remain = "☆12ハード参考表(未難#{remain_num})"
    end
  end

  def load_state_example
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Static::COLOR[j] }
  end

  def load_sheet
    unless User.exists?(iidxid: params[:iidxid])
      render file: Rails.root.join('public', '404.html'), status: 404, layout: true, content_type: 'text/html'
      return
    end
    load_static
    @sheets = Sheet.select(:id, :n_ability, :h_ability, :version, :title).active
    @scores = User.select(:id).find_by(iidxid: params[:iidxid]).scores.select(:sheet_id, :state).is_active
    @color = Score.convert_color(@scores)
    @stat = Score.stat_info(@scores)
  end

  def load_static
    @power = Static::POWER
    @list_color = Static::COLOR
    @versions = Static::VERSION
    @versions.push(['ALL', 0]) if @versions.count < 19
  end
end
