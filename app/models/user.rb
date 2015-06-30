# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  iidxid                 :string           not null
#  version                :integer          default(22), not null
#  djname                 :string           not null
#  grade                  :integer
#  pref                   :integer          not null
#  rival                  :text
#  reverse_rival          :text
#  admin                  :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#

class User < ActiveRecord::Base
  has_many :scores
  has_many :logs
  serialize :rival
  serialize :reverse_rival

  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable, :lockable
  attr_accessor :login

  include Rival

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
      find_by('username = :value OR iidxid = :value', value: login)
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
