class SignedRequestJob < ApplicationJob
  queue_as :default

  def perform(verb:, url:, body:, group_id:)
    actor = Group.find(group_id)
    conn = Faraday.new do |faraday|
      faraday.request :json
      faraday.response :json, parser_options: { symbolize_names: true }
      faraday.response :raise_error
    end
    conn.public_send(verb, url) do |faraday|
      faraday.body = body
      signature = HttpSignature.new(verb: verb, url: url, body: body, actor: actor)
      signature.headers.each do |key, value|
        faraday.headers[key] = value
      end
    end
  end
end
