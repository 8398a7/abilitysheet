class User < ActiveRecord::Base
  has_many :scores
  has_many :logs
  serialize :rival
  serialize :reverse_rival

  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  attr_accessor :login

  # usernameを必須・一意とする
  validates_uniqueness_of :username, :iidxid
  validates_presence_of :username, :djname, :iidxid, :grade, :pref

  validates :iidxid, format: {
    with: /\A\d{4}-\d{4}\z/,
    message: 'が正しくありません。'
  }, length: {
    is: 9
  }
  validates :grade, numericality: {
    only_integer: true
  }, inclusion: {
    in: Abilitysheet::Application.config.iidx_grade..17, message: 'のパラメタが異常です。'
  }
  validates :pref, numericality: {
    only_integer: true
  }, inclusion: {
    in: 0..47, message: 'のパラメタが異常です。'
  }
  validates :djname, length: { maximum: 6 }, format: { with: /\A[A-Z0-9\-\_.*!#&]+\z/, message: 'は半角大文字英字で記入して下さい' }
  validates :username, length: { maximum: 15 }, format: { with: /\A[a-z_0-9]+\z/, message: 'は半角英数字で記入して下さい' }

  scope :search_djname, ->(query) { User.where(['djname LIKE ?', "%#{PGconn.escape(query)}%"]) }

  module Special
    USERS = [1, 2, 3, 4, 5, 6, 8, 13, 16, 21, 34, 53, 63, 73, 100]
  end

  def special?
    Special::USERS.include?(id)
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      find_by(['username = :value OR iidxid = :value', { value: login }])
    else
      find_by(conditions)
    end
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    params.delete(:password) if params[:password].blank?
    params.delete(:password_confirmation) if params[:password_confirmation].blank?

    clean_up_passwords
    update_attributes(params, *options)
  end

  def belongs
    Static::PREF[pref]
  end

  def dan
    Static::GRADE[grade]
  end

  def dan_color
    if 3 <= grade && grade <= 10
      '#afeeee'
    elsif grade == 1 || grade == 2
      '#ff6347'
    elsif grade == 0
      '#ffd900'
    else
      '#98fb98'
    end
  end

  class << self
    def dan
      array = []
      Static::GRADE.each.with_index(Abilitysheet::Application.config.iidx_grade) { |d, i| array.push([d, i]) }
      array
    end

    def belongs
      array = []
      Static::PREF.each_with_index { |p, i| array.push([p, i]) }
      array
    end
  end

  # 登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
