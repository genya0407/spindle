class Users::InboxController < ApplicationController
  before_action :require_actor_signature!

  before_action do
    head :not_found unless target_group
  end

  def create
    json = params.require(:inbox).permit!.to_h.deep_symbolize_keys
    case json
    in { type: "Follow" }
      target_group.followerships.create_or_find_by!(remote_account: signed_request_actor)
      SignedRequestJob.perform_now(
        verb: :post,
        url: signed_request_actor.inbox,
        body: {
          "@context": "https://www.w3.org/ns/activitystreams",
          type: "Accept",
          object: json
        }.to_json,
        group_id: target_group.id
      )
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
