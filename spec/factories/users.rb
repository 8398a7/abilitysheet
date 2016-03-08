FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@iidx.tk" }
    djname 'TEST'
    iidxid '1234-5678'
    grade Abilitysheet::Application.config.iidx_grade
    pref 0
    username 'test'
    password 'hogehoge'
    role 100
  end
end
