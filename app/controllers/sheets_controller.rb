class SheetsController < ApplicationController
  before_action :check_action, except: :change_reverse
  before_action :detect_device_variant, only: :show

  def show
    @user = User.find_by_iidxid!(params[:iidxid])
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
    @color = Score.convert_color(@user.scores.is_current_version)
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
      return
    end
    @sheets = params['reverse_sheet'] ? @sheets.order(h_ability: :desc, title: :asc) : @sheets.order(:h_ability, :title)
  end

  def write_remain(type)
    @remain = @scores.remain_string([:clear, :hard][type])
  end

  def load_state_example
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Static::COLOR[j] }
  end

  def load_sheet
    load_static
    @sheets = Sheet.select(:id, :n_ability, :h_ability, :version, :title).active
    @scores = User.select(:id).find_by(iidxid: params[:iidxid]).scores.is_current_version.select(:sheet_id, :state).is_active
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
