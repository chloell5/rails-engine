FactoryBot.define do
  factory :item do
    name { Faker::Books::Dune.character }
    description { Faker::Books::Dune.planet }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
