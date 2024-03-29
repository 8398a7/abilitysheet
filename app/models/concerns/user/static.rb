# frozen_string_literal: true

module User::Static
  PREF = %w[
    海外
    北海道 青森県 岩手県 宮城県
    秋田県 山形県 福島県 茨城県
    栃木県 群馬県 埼玉県 千葉県
    東京都 神奈川県 新潟県 富山県
    石川県 福井県 山梨県 長野県
    岐阜県 静岡県 愛知県 三重県
    滋賀県 京都府 大阪府 兵庫県
    奈良県 和歌山県 鳥取県 島根県
    岡山県 広島県 山口県 徳島県
    香川県 愛媛県 高知県 福岡県
    佐賀県 長崎県 熊本県 大分県
    宮崎県 鹿児島県 沖縄県
    香港 韓国 台湾 マカオ シンガポール
    フィリピン アメリカ タイ インドネシア 米国 オーストラリア ニュージーランド
  ].freeze

  GRADE = %w[
    皆伝 中伝
    十段 九段
    八段 七段 六段 五段 四段 三段 二段 初段
    一級 二級 三級 四級 五級 六級 七級
    無段位
  ].freeze

  GRADE_COLOR = %w[
    #ffd900 #dcdddd
    #ff6347 #ff6347
    #afeeee #afeeee #afeeee #afeeee #afeeee #afeeee #afeeee #afeeee
    #98fb98 #98fb98 #98fb98 #98fb98 #98fb98 #98fb98 #98fb98
    #fbefef
  ].freeze
end
