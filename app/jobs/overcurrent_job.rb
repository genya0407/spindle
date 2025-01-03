class OvercurrentJob < ApplicationJob
  queue_as :default

  def self.deliver_to_followers(group:, boost_id:)
    inboxes = group.following_accounts.pluck(:inbox)
    jobs = inboxes.map { self.new(inbox_url: it, boost_id: boost_id) }
    ActiveJob.perform_all_later(jobs)
  end

  def perform(inbox_url:, boost_id:)
    boost = Boost.find(boost_id)
    SignedRequestJob.perform_now(
      verb: :post,
      url: inbox_url,
      body: {
        "@context": "https://www.w3.org/ns/activitystreams",
        id: boost.uri,
        to: "https://www.w3.org/ns/activitystreams#Public",
        cc: [ boost.actor.followers_uri ],
        type: "Announce",
        actor: boost.actor.uri,
        object: boost.original_status_uri
      }.to_json,
      group_id: boost.group_id
    )
  end
end
