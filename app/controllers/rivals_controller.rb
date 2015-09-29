class RivalsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_sheet, only: [:clear, :hard]

  def list
    rivals = User.find_by(id: current_user.id).rival
    load_rival(rivals)
  end

  def reverse_list
    rivals = User.find_by(id: current_user.id).reverse_rival
    load_rival(rivals)
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
    res = current_user.add_rival(params[:id])
    if res
      flash[:notice] = "ライバル(#{params[:id]})を追加しました"
    else
      flash[:alert] = '既に登録済みのライバルかライバルが10人を超えています'
    end
    render :reload
  end

  def remove
    current_user.remove_rival(params[:id])
    flash[:alert] = "ライバル(#{params[:id]})を削除しました"
    render :reload
  end

  private

  def load_rival(rivals)
    @users = User.where(iidxid: rivals)
    @scores_map = User.users_list(:rivals, @users)
    @color = Static::COLOR
  end

  def condition
    copy = @sheets
    @sheets = []
    rival_id = User.find_by(iidxid: params[:id]).id
    copy.each { |s| copy_sheets(s, rival_id) }
  end

  def copy_sheets(s, rival_id)
    m = s.scores.find_by(user_id: current_user.id)
    r = s.scores.find_by(user_id: rival_id)
    @sheets.push(s) if params[:condition] == 'win' && m.state < r.state
    @sheets.push(s) if params[:condition] == 'even' && m.state == r.state
    @sheets.push(s) if params[:condition] == 'lose' && m.state > r.state
  end

  def load_sheet
    @sheets = Sheet.active
    @state_examples = {}
    7.downto(0) { |j| @state_examples[Score.list_name[j]] = Static::COLOR[j] }
    @power = Static::POWER.dup
    s = User.find_by(iidxid: params[:id]).scores
    @rival_color = Score.convert_color(s)
    s = User.find_by(id: current_user.id).scores
    @my_color = Score.convert_color(s)
    @list_color = Static::COLOR
  end
end
