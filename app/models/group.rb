class Group < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :private_key, presence: true
  validates :public_key, presence: true

  has_many :followerships
  has_many :following_accounts, through: :followerships, source: :remote_account
  has_many :forwards
  has_many :boosts

  def update_keypair
    rsa = OpenSSL::PKey::RSA.generate(2048)

    self.private_key ||= rsa.export
    self.public_key ||= rsa.public_key.export
  end

  def uri = "https://#{Rails.configuration.x.local_domain}/users/#{name}"
  def inbox_uri = "#{uri}/inbox"
  def followers_uri = "#{uri}/followers"
  def following_uri = "#{uri}/following"

  def keypair
    @keypair ||= OpenSSL::PKey::RSA.new(private_key)
  end
end
