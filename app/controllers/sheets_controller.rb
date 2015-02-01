class SheetsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]

  def power
    @sheets = Sheet.active.preload(:static)
    @color = Score.convert_color(
      User.find_by(iidxid: params[:iidxid]).scores
    )
  end

  def clear
    @sheets = @sheets.order(:ability, :title)
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
  end

  private

  def version_stat
    @version_stat = []
    sum, versions = 0, (5..22).map(&:to_i)
    scores = User.find_by(iidxid: params[:iidxid]).scores
    state = (action_name == 'clear') ? 5 : 3
    versions.each do |version|
      sheet_ids = @sheets.where(version: version).pluck(:id)
      cnt = scores.where(sheet_id: sheet_ids, state: state..7).count
      sum += cnt
      @version_stat.push(cnt)
    end
    @version_stat.push(sum)
  end

  def set_sheet
    @sheets = Sheet.active
    version_stat
    @sheets = @sheets.where_version(version: params[:version])
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Score.list_color[j] }
    s = User.find_by(iidxid: params[:iidxid]).scores.where(sheet_id: @sheets.map(&:id))
    @color, @stat = Score.convert_color(s), Score.stat_info(s)
    @power, @list_color, @versions = Sheet.power, Score.list_color, Sheet.version
  end
end
