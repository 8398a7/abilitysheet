FactoryGirl.define do
  factory :user do
    djname 'TEST'
    iidxid '1234-5678'
    grade AbilitysheetIidx::Application.config.iidx_grade
    pref 0
    username 'test'
    password 'hogehoge'
    admin true
  end
end
