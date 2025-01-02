class WellKnown::NodeinfosController < ApplicationController
  def show
    json = {
      links: [
        {
          rel: "http://nodeinfo.diaspora.software/ns/schema/2.0",
          href: "https://#{local_domain}/nodeinfo/2.0"
        }
      ]
    }
    render json: json
  end
end
