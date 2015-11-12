class SheetsController < ApplicationController
  before_action :check_action, except: :change_reverse
  before_action :check_exist_user, except: :change_reverse

  def show
    unless params[:type] == 'power'
      load_sheet
      load_state_example
    end
    __send__(@action_routes[params[:type]])
    render @action_routes[params[:type]]
  end

  private

  def check_exist_user
    return if User.exists?(iidxid: params[:iidxid])
    return_404
  end

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
      User.find_by(iidxid: params[:iidxid]).scores.where(version: Abilitysheet::Application.config.iidx_version)
    )
  end

  def clear
    @sheet_type = 0
    reverse_check(@sheet_type)
    write_remain(@sheet_type)
  end

  def hard
    @sheet_type = 1
    reverse_check(@sheet_type)
    write_remain(@sheet_type)
  end

  def reverse_check(type)
    @power.reverse! if params['reverse_sheet']
    if type == 0
      @sheets = params['reverse_sheet'] ? @sheets.order(n_ability: :desc, title: :asc) : @sheets.order(:n_ability, :title)
    else
      @sheets = params['reverse_sheet'] ? @sheets.order(h_ability: :desc, title: :asc) : @sheets.order(:h_ability, :title)
    end
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
    @power = Static::POWER.dup
    @list_color = Static::COLOR
    @versions = Static::VERSION.dup
    @versions.push(['ALL', 0])
  end
end
