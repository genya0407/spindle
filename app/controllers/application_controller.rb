class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from RemoteAccount::AccountGone, with: :unauthorized

  include SignatureVerification

  private

  def default_url_options(options={})
    { :protocol => "https" }
  end

  def not_found
    head 404
  end

  def unauthorized
    head 401
  end

  def local_domain
    Rails.configuration.x.local_domain.presence
  end
end
