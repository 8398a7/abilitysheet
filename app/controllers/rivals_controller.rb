class RivalsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]
  before_filter :authenticate_user!

  def list
    rivals = User.find_by(id: current_user.id).rival
    @users = User.where(iidxid: rivals)
    @color = Score.list_color
  end

  def clear
    @sheets = Sheet.order(:ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def hard
    @sheets = Sheet.order(:h_ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def register
    u = User.find_by(id: current_user.id)
    array = []
    if u.rival
      array = u.rival
      res = rival_overlap(array)
    else
      res = true
    end

    if res
      array.push(params[:id])
      u.rival = array
      u.save
      flash[:notice] = "ライバル(#{ params[:id] })を追加しました"
    else
      flash[:alert] = '既に登録済みのライバルです'
    end
    redirect_to list_welcome_path
  end

  def remove
    u = User.find_by(id: current_user.id)
    array = []
    if u.rival
      array = u.rival if u.rival
      array.delete(params[:id])
      u.rival = array
      u.save
    end
    flash[:alert] = "ライバル(#{ params[:id] })を削除しました"
    redirect_to list_welcome_path
  end

  private

  def condition
    copy = @sheets
    @sheets = []
    rival_id = User.find_by(iidxid: params[:id]).id
    copy.each do |s|
      m = s.scores.find_by(user_id: current_user.id)
      r = s.scores.find_by(user_id: rival_id)
      @sheets.push(s) if params[:condition] == 'win' && m.state < r.state
      @sheets.push(s) if params[:condition] == 'even' && m.state == r.state
      @sheets.push(s) if params[:condition] == 'lose' && m.state > r.state
    end
  end

  def rival_overlap(rival)
    rival.each { |r| return false if r == params[:id] }
    true
  end

  def set_sheet
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Score.list_color[j] }
    @power = Sheet.power
    s = User.find_by(iidxid: params[:id]).scores
    @rival_color = Score.convert_color(s)
    s = User.find_by(id: current_user.id).scores
    @my_color = Score.convert_color(s)
    @list_color = Score.list_color
  end
end
