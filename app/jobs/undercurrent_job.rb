class UndercurrentJob < ApplicationJob
  queue_as :default

  def self.deliver_to_followers(group:, forward_id:)
    inboxes = group.following_accounts.pluck(:inbox)
    jobs = inboxes.map { self.new(inbox_url: it, forward_id: forward_id) }
    ActiveJob.perform_all_later(jobs)
  end

  def perform(inbox_url:, forward_id:)
    forward = Forward.find(forward_id)
    SignedRequestJob.perform_now(
      verb: :post,
      url: inbox_url,
      body: {
        "@context": "https://www.w3.org/ns/activitystreams",
        id: forward.uri,
        to: "Public",
        type: "Announce",
        actor: forward.actor.uri,
        object: forward.original_status_uri
      }.to_json,
      group_id: forward.group_id
    )
  end
end
