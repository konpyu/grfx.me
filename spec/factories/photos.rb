# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    lat     35.65858
    lng     139.745433
    address '東京都港区芝公園4-2-8'
    comment 'TOKIO TOWER!'
  end
end
