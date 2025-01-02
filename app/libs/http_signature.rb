class HttpSignature
  REQUEST_TARGET = "(request-target)".to_sym

  def initialize(verb:, url:, body:, actor:)
    @verb = verb
    @url = url
    @body = body
    @actor = actor
  end

  def headers
    sign_target_headers
      .except(REQUEST_TARGET)
      .merge(Signature: signature)
      .transform_keys(&:to_s)
  end

  private

  def signature
    algorithm = "rsa-sha256"
    signature = Base64.strict_encode64(@actor.keypair.sign(OpenSSL::Digest.new("SHA256"), sign_target_string))

    "keyId=\"#{@actor.uri}#main-key\",algorithm=\"#{algorithm}\",headers=\"#{sign_target_headers.keys.join(' ').downcase}\",signature=\"#{signature}\""
  end

  def sign_target_string
    sign_target_headers.map { |key, value| "#{key.downcase}: #{value}" }.join("\n")
  end

  def sign_target_headers
    {
      Date: date,
      Digest: digest,
      REQUEST_TARGET => request_target
    }
  end

  def date
    @date ||= Time.now.utc.httpdate
  end

  def digest
    @digest ||= "SHA-256=#{Digest::SHA256.base64digest(@body)}"
  end

  def request_target
    @request_target ||=
      begin
        url = URI.parse(@url)
        verb = @verb.to_s.downcase
        if url.query
          "#{verb} #{url.path}?#{url.query}"
        else
          "#{verb} #{url.path}"
        end
      end
  end
end
