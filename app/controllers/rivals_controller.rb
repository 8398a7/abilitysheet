class RivalsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]
  before_filter :authenticate_user!

  def list
    rivals = User.find_by(id: current_user.id).rival
    rival_set(rivals)
  end

  def reverse_list
    rivals = User.find_by(id: current_user.id).reverse_rival
    rival_set(rivals)
  end

  def clear
    @sheets = @sheets.active.order(:ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def hard
    @sheets = @sheets.order(:h_ability, :title)
    return if params[:condition] == 'all'
    condition if params[:condition]
  end

  def register
    u = User.find_by(id: current_user.id)
    r = User.find_by(iidxid: params[:id])
    array, r_array = [], []
    res = true
    if u.rival
      array = u.rival
      res = rival_overlap(array)
      res = false if 9 < u.rival.count
    end

    if r.reverse_rival
      r_array = r.reverse_rival
      res = rival_overlap(r_array)
    else
      res = true
    end

    if res
      r_array.push(current_user.iidxid)
      array.push(params[:id])
      u.rival, r.reverse_rival = array, r_array
      u.save
      r.save
      flash[:notice] = "ライバル(#{ params[:id] })を追加しました"
    else
      flash[:alert] = '既に登録済みのライバルかライバルが10人を超えています'
    end
    redirect_to :back
  end

  def remove
    u = User.find_by(id: current_user.id)
    r = User.find_by(iidxid: params[:id])
    array, r_array = [], []
    if u.rival
      array = u.rival if u.rival
      r_array = r.reverse_rival
      array.delete(params[:id])
      r_array.delete(current_user.iidxid)
      u.rival, r.reverse_rival = array, r_array
      u.save
      r.save
    end
    flash[:alert] = "ライバル(#{ params[:id] })を削除しました"
    redirect_to :back
  end

  private

  def rival_set(rivals)
    @users = User.where(iidxid: rivals)
    @color = Score.list_color
  end

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
    @sheets = Sheet.active
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
