module SelectHelper
  def check_boxes_prefs
    User::Static::PREF.map do |pref|
      User.new(pref: User::Static::PREF.index(pref))
    end
  end
end
