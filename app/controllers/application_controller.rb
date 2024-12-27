class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    head 404
  end

  def local_domain
    Rails.configuration.x.local_domain.presence
  end
end
