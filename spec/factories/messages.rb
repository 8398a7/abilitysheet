FactoryGirl.define do
  factory :message do
    body 'message'
    ip IPAddr.new('192.168.0.1')
  end
end
