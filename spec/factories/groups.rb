FactoryBot.define do
  factory :group do
    name { SecureRandom.hex(8) }
  end
end
