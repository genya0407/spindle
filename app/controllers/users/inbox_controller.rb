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
      SignedRequestJob.perform_later(
        verb: :post, url: signed_request_actor.inbox,
        body: LinkedDataSignature
                .new("@context": "https://www.w3.org/ns/activitystreams", type: "Accept", object: json)
                .sign!(target_group)
                .to_json,
        group_id: target_group.id
      )
    in { type: "Undo", object: { type: "Follow" } }
      target_group.followerships.find_by(remote_account: signed_request_actor)&.destroy!
    in { type: "Create", to:, object: { type: "Note", id:, tag: } } if [tag].flatten.find { |t| t[:type] = "Mention" }&.dig(:href) == target_group.uri && ([to].flatten & [ "Public", "as:Public", "https://www.w3.org/ns/activitystreams#Public" ]).present?
      if json[:object][:inReplyTo]
        forward = target_group.forwards.create_or_find_by!(original_status_uri: id) { it.json = json }
        UndercurrentJob.deliver_to_followers(group: target_group, forward_id: forward.id)
      else
        boost = target_group.boosts.create_or_find_by!(original_status_uri: id)
        OvercurrentJob.deliver_to_followers(group: target_group, boost_id: boost.id)
      end
    else
      Rails.logger.info { "Unsupported type: #{params[:type].inspect}. #{params.to_json}" }
    end
  end

  private
  def target_group
    @target_group ||= Group.find_by(name: params[:id])
  end
end
