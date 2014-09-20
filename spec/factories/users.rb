# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:urlname) { |i| "urlname#{i}" }
  factory :user do
    urlname
  end
end
