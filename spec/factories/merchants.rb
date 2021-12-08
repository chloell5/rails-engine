FactoryBot.define do
  factory :merchant do
    name { Faker::Books::Dune.saying }
  end
end
