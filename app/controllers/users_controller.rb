class UsersController < ApplicationController
  before_action do
    head :not_found unless target_group
  end

  def show
    account = {
      "@context": [ "https://www.w3.org/ns/activitystreams", LinkedDataSignature::SIGNATURE_CONTEXT ],
      id: target_group.uri,
      type: "Group",
      inbox: inbox_user_url(id: target_group.name),
      outbox: outbox_user_url(id: target_group.name),
      followers: followers_user_url(id: target_group.name),
      following: following_user_url(id: target_group.name),
      name: target_group.name,
      preferredUsername: target_group.name,
      summary: target_group.summary,
      icon: {
        type: "Image",
        url: "https://#{local_domain}/spindler.png",
      },
      published: target_group.created_at.iso8601,
      publicKey: {
        id: "https://#{local_domain}/users/#{target_group.name}#main-key",
        type: "CryptographicKey",
        owner: "https://#{local_domain}/users/#{target_group.name}",
        publicKeyPem: target_group.public_key
      }
    }
    render json: account, content_type: "application/activity+json"
  end

  def following

  end

  def followers

  end

  private
  def target_group
    @target_group ||= Group.find_by(name: params[:id])
  end
end
