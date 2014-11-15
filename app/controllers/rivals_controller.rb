class RivalsController < ApplicationController
  before_action :set_sheet, only: [:clear, :hard]

  def clear
    @sheets = Sheet.order(:ability, :title)
  end

  def hard
    @sheets = Sheet.order(:h_ability, :title)
  end

  def register
    u = User.find_by(id: current_user.id)
    array = []
    if u.rival
      array = u.rival
      res = rival_overlap(array)
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

  def rival_overlap(rival)
    rival.each { |r| return false if r == params[:id] }
    true
  end

  def set_sheet
    @power = Sheet.power
    s = User.find_by(iidxid: params[:id]).scores
    @rival_color = Score.convert_color(s)
    s = User.find_by(id: current_user.id).scores
    @my_color = Score.convert_color(s)
    @list_color = Score.list_color
  end
end
