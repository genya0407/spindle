class Users::InboxController < ApplicationController
  # before_action :require_actor_signature!

  def create
    Rails.logger.debug { request.body.read }
    Rails.logger.debug { request.headers.to_h }
  end
end
