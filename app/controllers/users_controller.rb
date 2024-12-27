class UsersController < ApplicationController
  def show
    group = Group.find_by!(name: params[:id])
    account = {
      "@context": ["https://www.w3.org/ns/activitystreams"],
      id: "https://#{local_domain}/users/#{group.name}",
      type: "Group",
      inbox: "https://#{local_domain}/users/#{group.name}/inbox",
      outbox: "https://#{local_domain}/users/#{group.name}/outbox",
      preferredUsername: group.name,
      name: group.name,
      # TODO:
      summary: "...snip...",
      published: group.created_at.iso8601,
      # publicKey: {
      #   id: "https://#{local_domain}/users/#{group.name}#main-key",
      #   owner: "https://#{local_domain}/users/#{group.name}",
      #   publicKeyPem: "...snip..."
      # },
      # endpoints: {sharedInbox: "https://#{local_domain}/inbox"},
    }
    render json: account, content_type: 'application/activity+json'
  end
end
