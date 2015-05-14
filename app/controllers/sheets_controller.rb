class SheetsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]
  before_action :set_state_example, only: [:clear, :hard]

  def power
    @sheets = Sheet.active.preload(:static)
    @color = Score.convert_color(
      User.find_by(iidxid: params[:iidxid]).scores
    )
  end

  def clear
    @sheets = @sheets.order(:ability, :title)
    gon.sheet_type = 0
    write_remain(0, params)
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
    gon.sheet_type = 1
    write_remain(1, params)
  end

  private

  def write_remain(type, params)
    return if current_user.iidxid != params[:iidxid]
    if type == 0
      remain_num = @scores.where(state: 5..7).is_active.count
      @remain = "☆12ノマゲ参考表(未クリア#{remain_num})"
    else
      remain_num = @scores.where(state: 3..7).is_active.count
      @remain = "☆12ハード参考表(未難#{remain_num})"
    end
  end

  def set_state_example
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Score.list_color[j] }
  end

  def set_sheet
    @sheets = Sheet.active
    s = User.find_by(iidxid: params[:iidxid]).scores.where(sheet_id: @sheets.map(&:id))
    @color, @stat = Score.convert_color(s), Score.stat_info(s)
    @power, @list_color, @versions = Sheet.power, Score.list_color, Sheet.version
    @scores = User.find_by(iidxid: params[:iidxid]).scores
  end
end
