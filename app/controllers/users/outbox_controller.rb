class Users::OutboxController < ApplicationController
  before_action :require_actor_signature!

  before_action do
    head :not_found unless target_group
  end

  def create
  end

  private
  def target_group
    @target_group ||= Group.find_by(name: params[:id])
  end
end
