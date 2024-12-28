class Users::InboxController < ApplicationController
  before_action :require_actor_signature!

  before_action do
    head :not_found unless target_group
  end

  def create
    case params.require(:inbox).permit!.to_h.deep_symbolize_keys
    in { type: "Follow" }
      target_group.followerships.create_or_find_by!(remote_account: signed_request_actor)
    in { type: "Undo", object: { type: "Follow" } }
      target_group.followerships.find_by(remote_account: signed_request_actor)&.destroy!
    else
      Rails.logger.info { "Unsupported type: #{params[:type].inspect}. #{params.to_json}" }
    end
  end

  private
  def target_group
    @target_group ||= Group.find_by(name: params[:id])
  end
end
