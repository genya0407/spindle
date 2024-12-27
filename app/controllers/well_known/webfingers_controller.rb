class WellKnown::WebfingersController < ApplicationController
  def show
    type, username, domain = params[:resource].split(/[:@]/)
    if type == 'acct' && username.present? && domain == Rails.configuration.x.local_domain
      username
      account = {
        subject: "acct:#{username}@#{domain}",
        links: [
          {
            rel: "self",
            type: "application/activity+json",
            href: "https://#{domain}/users/#{username}"
          },
          # TODO:
          # {
          #   "rel": "http://webfinger.net/rel/avatar",
          #   "type": "image/jpeg",
          #   "href": "https://media-#{domain}/accounts/avatars/110/662/555/427/838/308/original/bf19b28d9a2f6875.jpg"
          # }
        ]
      }
      render json: account, content_type: 'application/jrd+json'
    else
      head 404
    end
  end
end
