class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :white_list

  def index
    @message = Message.exists?(state: false)
  end

  def message_list
    @messages = Message.all
  end

  def message_change
    message = Message.find_by(id: params[:id])
    message.state = message.state ? false : true
    message.save
    redirect_to message_list_admins_path
  end

  def new_notice
    @elem = Notice.new
  end

  def create_notice
    notice = Notice.new
    notice.body = params[:notice][:body]
    notice.state = params[:notice][:state]
    notice.save
    flash[:notice] = "#{ notice.body }を追加しました"
    redirect_to new_notice_admins_path
  end

  def create_sheet
    sheet = Sheet.new
    sheet.title = params[:sheet][:title]
    sheet.ability = params[:sheet][:ability]
    sheet.h_ability = params[:sheet][:h_ability]
    sheet.version = params[:sheet][:version]
    sheet.save
    users = User.all
    version = AbilitysheetIidx::Application.config.iidx_version
    users.each { |user| Score.create(user_id: user.id, sheet_id: sheet.id, version: version) }
    flash[:notice] = "#{ sheet.title }を追加しました"
    redirect_to new_sheet_admins_path
  end

  def new_sheet
    @sheet = Sheet.new
    @versions = [['5',    5],
                 ['6',    6],
                 ['7',    7],
                 ['8',    8],
                 ['9',    9],
                 ['10',   10],
                 ['RED',  11],
                 ['HS',   12],
                 ['DD',   13],
                 ['GOLD', 14],
                 ['DJT',  15],
                 ['EMP',  16],
                 ['SIR',  17],
                 ['RA',   18],
                 ['Lin',  19],
                 ['tri',  20],
                 ['SPD',  21],
                 ['PEN',  22]]
  end
end
