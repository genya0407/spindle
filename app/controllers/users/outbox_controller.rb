class Users::OutboxController < ApplicationController
  before_action do
    head :not_found unless target_group
  end

  def show
    json = {
      "@context": "https://www.w3.org/ns/activitystreams",
      id: outbox_user_url(id: target_group.name),
      type: "OrderedCollection",
      totalItems: target_group.boosts.count,
      orderedItems: target_group.boosts.order(id: :desc).limit(100).map do |boost|
        {
          "@context": "https://www.w3.org/ns/activitystreams",
          id: boost.uri,
          to: "https://www.w3.org/ns/activitystreams#Public",
          cc: [ boost.actor.followers_uri ],
          type: "Announce",
          actor: boost.actor.uri,
          object: boost.original_status_uri
        }
      end
    }
    render json: json
  end

  private
  def target_group
    @target_group ||= Group.find_by(name: params[:id])
  end
end
