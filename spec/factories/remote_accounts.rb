FactoryBot.define do
  factory :remote_account do
    uri { "https://#{domain}/users/#{name}" }
    name { SecureRandom.hex(8) }
    domain { "test.com" }
    public_key { "dummy" }
  end
end
