class WellKnown::WebfingersController < ApplicationController
  def show
    type, name, domain = params[:resource].split(/[:@]/)
    return head 404 unless type == "acct" && name.present? && domain == local_domain

    group = Group.find_by!(name:)
    json = {
      subject: "acct:#{group.name}@#{local_domain}",
      links: [
        {
          rel: "self",
          type: "application/activity+json",
          href: "https://#{local_domain}/users/#{group.name}"
        }
        # TODO:
        # {
        #   "rel": "http://webfinger.net/rel/avatar",
        #   "type": "image/jpeg",
        #   "href": "https://media-#{domain}/accounts/avatars/110/662/555/427/838/308/original/bf19b28d9a2f6875.jpg"
        # }
      ]
    }
    render json: json, content_type: "application/jrd+json"
  end
end
