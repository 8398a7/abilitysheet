FactoryGirl.define do
  factory :log do
    version Abilitysheet::Application.config.iidx_version
    created_date Date.today
  end
end
