FactoryBot.define do
  factory :group do
    name { SecureRandom.hex(8) }
    summary { SecureRandom.hex(8) }
    after(:build) do |group|
      group.update_keypair
    end
  end
end
