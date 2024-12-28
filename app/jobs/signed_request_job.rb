class SignedRequestJob < ApplicationJob
  queue_as :default

  def perform(verb:, url:, body:, group_id:)
    actor = Group.find(group_id)
    signature = Signature.new(verb: verb, url: url, body: body, actor: actor)
    conn = Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, parser_options: { symbolize_names: true }
      faraday.response :raise_error
    end
    conn.public_send(verb, url) do |faraday|
      faraday.headers["Content-Type"] = "application/activity+json"
      faraday.body = body
      signature.headers.each do |key, value|
        faraday.headers[key] = value
      end
    end
  end
end
