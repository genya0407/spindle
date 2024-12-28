class RemoteAccount < ApplicationRecord
  validates :uri, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { scope: :domain }, format: { with: /[a-z0-9_]+([.-]+[a-z0-9_]+)*/i }
  validates :domain, presence: true
  validates :public_key, presence: true
  validates :inbox, presence: true

  class AccountGone < StandardError; end

  def self.find_or_create_by_uri!(uri:)
    uri = uri.split("#").first
    if uri.start_with?("acct:")
      name, domain = uri.delete_prefix("acct:").delete_prefix("@").split("@")
      self.find_by(name: name, domain: domain) || create_by_name_and_domain!(name: name, domain: domain)
    else
      self.find_by(uri: uri) || create_by_uri!(uri: uri)
    end
  end

  def self.create_by_name_and_domain!(name:, domain:)
    conn = Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, parser_options: { symbolize_names: true }
    end
    response = conn.get("https://#{domain}/.well-known/webfinger", resource: "acct:#{name}@#{domain}")
    raise AccountGone if response.status == 410 # account deleted already
    raise "unexpected status code: #{response.status}, #{response.body.inspect}" unless response.success?

    json = response.body
    create_by_uri!(uri: json[:links].find { |link| link[:rel] == "self" }[:href])
  end

  def self.create_by_uri!(uri:)
    conn = Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, parser_options: { symbolize_names: true }
      faraday.headers[:accept] = "application/activity+json, application/ld+json"
    end
    response = conn.get(uri)
    raise AccountGone if response.status == 410 # account deleted already
    raise "unexpected status code: #{response.status}, #{response.body.inspect}" unless response.success?
    json = response.body

    self.create_or_find_by!(
      uri: uri,
      name: json[:name],
      domain: URI.parse(uri).host,
      public_key: json.dig(:publicKey, :publicKeyPem),
      inbox: json[:inbox]
    )
  end

  def update_key!
    conn = Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, parser_options: { symbolize_names: true }
      faraday.response :raise_error
      faraday.headers[:accept] = "application/activity+json, application/ld+json"
    end
    json = conn.get(uri).body
    self.update!(public_key: json.dig(:publicKey, :publicKeyPem))
  end

  def acct
    "acct:#{name}@#{domain}"
  end
end
