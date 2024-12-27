class UsersController < ApplicationController
  def show
    id = params[:id]
    account = {
      "@context": ["https://www.w3.org/ns/activitystreams"],
      id: "https://#{Rails.configuration.x.local_domain}/users/#{id}",
      type: "Group",
      following: "https://#{Rails.configuration.x.local_domain}/users/#{id}/following",
      followers: "https://#{Rails.configuration.x.local_domain}/users/#{id}/followers",
      inbox: "https://#{Rails.configuration.x.local_domain}/users/#{id}/inbox",
      outbox: "https://#{Rails.configuration.x.local_domain}/users/#{id}/outbox",
      preferredUsername: id,
      name: id,
      # TODO:
      summary: "...snip...",
      published: "2023-07-05T00:00:00Z",
      # publicKey: {
      #   id: "https://#{Rails.configuration.x.local_domain}/users/#{id}#main-key",
      #   owner: "https://#{Rails.configuration.x.local_domain}/users/#{id}",
      #   publicKeyPem: "...snip..."
      # },
      # endpoints: {sharedInbox: "https://#{Rails.configuration.x.local_domain}/inbox"},
    }
    render json: account, content_type: 'application/activity+json'
  end
end
