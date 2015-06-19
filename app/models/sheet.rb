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

  after_create :create_score_and_static

  def create_score_and_static
    SheetWorker.perform_async(id)
  end

  class << self
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
