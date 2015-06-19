class SheetsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]
  before_action :set_state_example, only: [:clear, :hard]

  def power
    @sheets = Sheet.active.preload(:ability)
    @color = Score.convert_color(
      User.find_by(iidxid: params[:iidxid]).scores
    )
  end

  def clear
    @sheets = @sheets.order(:ability, :title)
    gon.sheet_type = 0
    write_remain(0)
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
    gon.sheet_type = 1
    write_remain(1)
  end

  private

  def write_remain(type)
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
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Grade::COLOR[j] }
  end

  def set_sheet
    unless User.exists?(iidxid: params[:iidxid])
      render file: Rails.root.join('public', '404.html'), status: 404, layout: true, content_type: 'text/html'
      return
    end
    @sheets = Sheet.active
    s = User.find_by(iidxid: params[:iidxid]).scores.where(sheet_id: @sheets.map(&:id))
    @color = Score.convert_color(s)
    @stat = Score.stat_info(s)
    @power = Grade::POWER
    @list_color = Grade::COLOR
    @versions = Grade::VERSION
    @scores = User.find_by(iidxid: params[:iidxid]).scores
  end
end
