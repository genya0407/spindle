class NodeinfosController < ApplicationController
  def show
    # json = {
    #   openRegistrations: false,
    #   protocols: [
    #     activitypub"
    #   ],
    #   software: {
    #     name: "spindler",
    #     version: "0.1.0"
    #   },
    #   usage: {
    #     users: {
    #       total: Group.count
    #     }
    #   },
    #   version: "2.1"
    # }
    json = {
      version: "2.0",
      software: {
        name: "mastodon",
        version: "4.3.2"
      },
      protocols: [
        "activitypub"
      ],
      services: {
        outbound: [],
        inbound: []
      },
      openRegistrations: false,
      metadata: {
        nodeName: local_domain,
        nodeDescription: ""
      }
    }
    render json: json
  end
end
