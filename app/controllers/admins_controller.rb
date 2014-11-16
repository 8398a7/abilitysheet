class AdminsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :white_list

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
    redirect_to register_admins_path
  end

  def register
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
