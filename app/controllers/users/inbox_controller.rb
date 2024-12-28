class Users::InboxController < ApplicationController
  before_action :require_actor_signature!

  def create
    Rails.logger.debug { request.body.read }
  end
end
