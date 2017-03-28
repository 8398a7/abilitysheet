# frozen_string_literal: true

class RivalsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sheet, only: %i(clear hard)

  def list
    @users = current_user.following
    load_rival
  end

  def reverse_list
    @users = current_user.followers
    load_rival
  end

  def clear
    @sheets = @sheets.active.order(:n_ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def register
    current_user.follow(params[:id]) ? flash[:notice] = "ライバル(#{params[:id]})を追加しました" : flash[:alert] = '既に登録済みのライバルです'
    render :reload
  end

  def remove
    current_user.unfollow(params[:id]) ? flash[:notice] = "ライバル(#{params[:id]})を削除しました" : flash[:alert] = 'ライバルに登録されていません'
    render :reload
  end

  private

  def load_rival
    @scores_map = User.users_list(:rivals, @users)
    @color = Static::COLOR
  end

  def condition
    copy = @sheets
    @sheets = []
    rival_id = User.find_by_iidxid!(params[:id]).id
    copy.each { |s| copy_sheets(s, rival_id) }
  end

  def copy_sheets(s, rival_id)
    m_state = s.scores.is_current_version.find_by_user_id(current_user.id).try(:state) || 7
    r_state = s.scores.is_current_version.find_by_user_id(rival_id).try(:state) || 7
    @sheets.push(s) if params[:condition] == 'win' && m_state < r_state
    @sheets.push(s) if params[:condition] == 'even' && m_state == r_state
    @sheets.push(s) if params[:condition] == 'lose' && m_state > r_state
  end

  def load_sheet
    @sheets = Sheet.active
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Static::COLOR[j] }
    @power = Static::POWER.dup
    s = User.find_by_iidxid!(params[:id]).scores.is_current_version
    @rival_color = Score.convert_color(s)
    s = current_user.scores.is_current_version
    @my_color = Score.convert_color(s)
    @list_color = Static::COLOR
  end
end
