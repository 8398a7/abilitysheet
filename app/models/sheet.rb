class Sheet < ActiveRecord::Base
  has_many :scores
  has_many :logs
  has_one :static

  delegate :e,   to: :static
  delegate :c,   to: :static
  delegate :h,   to: :static
  delegate :exh, to: :static
  delegate :fc,  to: :static
  delegate :aaa, to: :static

  scope :active, -> { where(active: true) }

  class << self
    def create_sheet(params)
      s = Sheet.create(
        title: params[:sheet][:title],
        ability: params[:sheet][:ability],
        h_ability: params[:sheet][:h_ability],
        version: params[:sheet][:version]
      )
      version = AbilitysheetIidx::Application.config.iidx_version
      User.all.each { |u| Score.create(user_id: u.id, sheet_id: s.id, version: version) }
      d = 99.99
      Static.create(
        sheet_id: s.id,
        fc: d, exh: d, h: d, c: d, e: d, aaa: d
      )
      s
    end

    def where_version(params)
      return all if params[:version].nil? || params[:version] == '0'
      where(version: params[:version])
    end

    def power
      [['地力S+', 0],
       ['個人差S+', 1],
       ['地力S', 2],
       ['個人差S', 3],
       ['地力A+', 4],
       ['個人差A+', 5],
       ['地力A', 6],
       ['個人差A', 7],
       ['地力B+', 8],
       ['個人差B+', 9],
       ['地力B', 10],
       ['個人差B', 11],
       ['地力C', 12],
       ['個人差C', 13],
       ['地力D', 14],
       ['個人差D', 15],
       ['地力E', 16],
       ['個人差E', 17],
       ['地力F', 18],
       ['難易度未定', 19]]
    end

    def version
      [['5',    5,  'btn btn-link'],
       ['6',    6,  'btn btn-link'],
       ['7',    7,  'btn btn-link'],
       ['8',    8,  'btn btn-link'],
       ['9',    9,  'btn btn-link'],
       ['10',   10, 'btn btn-link'],
       ['RED',  11, 'btn btn-danger'],
       ['HS',   12, 'btn btn-primary'],
       ['DD',   13, 'btn btn-default'],
       ['GOLD', 14, 'btn btn-info'],
       ['DJT',  15, 'btn btn-success'],
       ['EMP',  16, 'btn btn-danger'],
       ['SIR',  17, 'btn btn-primary'],
       ['RA',   18, 'btn btn-warning'],
       ['Lin',  19, 'btn btn-default'],
       ['tri',  20, 'btn btn-primary'],
       ['SPD',  21, 'btn btn-warning'],
       ['PEN',  22, 'btn btn-danger'],
       ['ALL',  0,  'btn btn-success']]
    end
  end
end
