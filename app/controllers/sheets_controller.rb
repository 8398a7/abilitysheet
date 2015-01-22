class SheetsController < ApplicationController
  before_action :set_sheet

  def power
    @sheets = Sheet.active.preload(:static)
  end

  def clear
    @sheets = @sheets.order(:ability, :title)
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
  end

  private

  def version_check
    @sheets = @sheets.where(version: params[:version]) if params[:version] && params[:version] != '0'
  end

  def version_stat
    @version_stat = []
    versions = (5..22).map(&:to_i)
    scores = User.find_by(iidxid: params[:iidxid]).scores
    state = 5
    sum = 0
    versions.each do |version|
      sheet_ids = @sheets.where(version: version).pluck(:id)
      @version_stat.push(scores.where(sheet_id: sheet_ids, state: state..7).count)
    end
    @version_stat.each { |v| sum += v }
    @version_stat.push(sum)
  end

  def set_sheet
    @sheets = Sheet.active
    version_stat
    version_check
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Score.list_color[j] }
    @power = Sheet.power
    s = User.find_by(iidxid: params[:iidxid]).scores.where(sheet_id: @sheets.map(&:id))
    @color = Score.convert_color(s)
    @list_color = Score.list_color
    @stat = Score.stat_info(s)
    @versions = Sheet.version
  end
end
