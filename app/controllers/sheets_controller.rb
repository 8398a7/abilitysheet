class SheetsController < ApplicationController
  before_action :load_sheet, only: [:clear, :hard]
  before_action :load_state_example, only: [:clear, :hard]

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

  private

  def write_remain(type)
    if type == 0
      remain_num = @scores.select(:state).where(state: 5..7).is_active.count
      @remain = "☆12ノマゲ参考表(未クリア#{remain_num})"
    else
      remain_num = @scores.select(:state).where(state: 3..7).is_active.count
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
    @sheets = Sheet.active
    @scores = User.find_by(iidxid: params[:iidxid]).scores.is_active
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
